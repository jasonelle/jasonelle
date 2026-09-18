//
//  JLKernel/WebView.kt
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-15
//  Made with love in Chile.
//
//  Copyright (c) Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels at https://jasonelle.com.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/agpl-3.0.txt>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.

package com.jasonelle.kernel

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.webkit.JavascriptInterface
import android.webkit.WebChromeClient
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.browser.customtabs.CustomTabsIntent
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.viewinterop.AndroidView
import org.json.JSONObject

enum class NavigationPolicy {
  ALLOW,
  CANCEL,
}

class Coordinator(
  val config: AppConfiguration,
  val plugins: Map<String, Plugin>,
) {
  val logger = Logger(Coordinator::class.java)
  var webView: WebView? = null
  private val mainHandler = Handler(Looper.getMainLooper())

  @JavascriptInterface
  fun postMessage(messageJson: String) {
    logger.debug("Received raw message from JS: $messageJson")
    try {
      val json = JSONObject(messageJson)
      val name = json.optString("name", "")
      val callbackId = json.optString("callbackId", "")
      val argsObj = json.optJSONObject("args")
      val argsMap = mutableMapOf<String, Any?>()

      if (argsObj != null) {
        val keys = argsObj.keys()
        while (keys.hasNext()) {
          val key = keys.next()
          argsMap[key] = argsObj.opt(key)
        }
      } else if (json.has("args") && !json.isNull("args")) {
        argsMap["args"] = json.opt("args")
      }

      handleMessage(name, callbackId, argsMap)
    } catch (e: Exception) {
      logger.warning("Failed to parse message from JS: ${e.message}")
    }
  }

  /**
   * Dispatches message to target plugin, extracted for testing.
   */
  fun handleMessage(
    name: String,
    callbackId: String,
    args: Map<String, Any?>,
  ) {
    val plugin = plugins[name]
    if (plugin == null) {
      logger.warning("No plugin registered for message: $name")
      return
    }

    plugin.handle_call(callbackId, args) { script ->
      respondToJS(script)
    }
  }

  fun respondToJS(script: String) {
    logger.debug("Evaluating $script")
    mainHandler.post {
      webView?.evaluateJavascript(script) { result ->
        logger.debug("JS execution result: $result")
      }
    }
  }

  /**
   * Decides whether a navigation should proceed in the webview or open externally in Custom Tabs.
   * If `allowed` is empty or null, all URLs load in the webview.
   * Otherwise URLs whose host is in `allowed` load in the webview, plus the app's own main URL,
   * and any other URL opens in Custom Tabs.
   */
  fun decidePolicy(
    url: Uri?,
    allowed: List<String>?,
    mainURL: Uri?,
  ): NavigationPolicy = decidePolicyForHost(url?.host, allowed, mainURL?.host)

  /**
   * Host-only policy decision, extracted for JVM unit testing.
   */
  fun decidePolicyForHost(
    host: String?,
    allowed: List<String>?,
    mainHost: String?,
  ): NavigationPolicy {
    if (allowed == null || allowed.isEmpty()) {
      return NavigationPolicy.ALLOW
    }
    val h = host ?: return NavigationPolicy.CANCEL
    if (allowed.contains(h) || h.equals(mainHost, ignoreCase = true)) {
      return NavigationPolicy.ALLOW
    }
    return NavigationPolicy.CANCEL
  }

  fun openInCustomTabs(
    context: Context,
    url: Uri,
  ) {
    try {
      logger.debug("Opening Custom Tabs for $url")
      val customTabsIntent = CustomTabsIntent.Builder().build()
      customTabsIntent.launchUrl(context, url)
    } catch (e: Exception) {
      logger.warning("Failed to open Custom Tabs, falling back to browser: ${e.message}")
      val intent = Intent(Intent.ACTION_VIEW, url)
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      context.startActivity(intent)
    }
  }
}

object JasonelleBridge {
  const val JAVASCRIPT_INTERFACE_NAME = "jasonelleBridge"

  const val JS_BRIDGE_SCRIPT = """
    const ___jasonelle_uuid = () => {
      const bytes = crypto.getRandomValues(new Uint8Array(16));

      bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
      bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant

      return [...bytes]
        .map((b, i) => {
          const hex = b.toString(16).padStart(2, '0');
          return [4, 6, 8, 10].includes(i) ? `-${'$'}{hex}` : hex;
        })
        .join('');
    };

    window.jasonelle = {
        _callbacks: {},
        result: {
          resolve: function(args) {
            if (args && args.callbackId && window.jasonelle._callbacks[args.callbackId]) {
                const [resolve, reject] = window.jasonelle._callbacks[args.callbackId];
                delete window.jasonelle._callbacks[args.callbackId];
                delete args.callbackId;
                resolve(args);
            }
          },
          reject: function(args) {
            if (args && args.callbackId && window.jasonelle._callbacks[args.callbackId]) {
                const [resolve, reject] = window.jasonelle._callbacks[args.callbackId];
                delete window.jasonelle._callbacks[args.callbackId];
                delete args.callbackId;
                reject(args);
            }
          },
        },
        post: function(name, args) {
            var callbackId = ___jasonelle_uuid();
            return new Promise(function(resolve, reject) {
                window.jasonelle._callbacks[callbackId] = [resolve, reject];
                if (window.jasonelleBridge && window.jasonelleBridge.postMessage) {
                    window.jasonelleBridge.postMessage(JSON.stringify({ name: name, args: args, callbackId: callbackId }));
                } else if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.jasonelle) {
                    window.webkit.messageHandlers.jasonelle.postMessage({ name: name, args: args, callbackId: callbackId });
                }
            });
        },
        plugins: {},
        plugin: {
            init: function(name, id) {
              const plugin = {
                name, 
                id,
                handle_call: function(){},
                handle_event: function(){},
              };
              console.log(`${'$'}{plugin.id}: Init`);
              return plugin;
          }
        },
        handle: function(args) {
          console.log("Jasonelle", "Handled event", args);
        },
    };

    if (!window.webkit) {
        window.webkit = {
            messageHandlers: {
                jasonelle: {
                    postMessage: function(msg) {
                        if (window.jasonelleBridge && window.jasonelleBridge.postMessage) {
                            window.jasonelleBridge.postMessage(typeof msg === 'string' ? msg : JSON.stringify(msg));
                        }
                    }
                }
            }
        };
    }
    """
}

@SuppressLint("SetJavaScriptEnabled")
fun createJasonelleWebView(
  context: Context,
  config: AppConfiguration,
  plugins: Map<String, Plugin>,
): WebView {
  val logger = Logger("JasonelleWebView")
  val coordinator = Coordinator(config, plugins)

  if (config.inspectable == true) {
    logger.debug("WebView inspection: enabled")
    WebView.setWebContentsDebuggingEnabled(true)
  } else {
    logger.debug("WebView inspection: disabled")
    WebView.setWebContentsDebuggingEnabled(false)
  }

  val webView =
    WebView(context).apply {
      settings.javaScriptEnabled = true
      settings.domStorageEnabled = true
      settings.databaseEnabled = true
      settings.allowFileAccess = false
      settings.allowContentAccess = false

      addJavascriptInterface(coordinator, JasonelleBridge.JAVASCRIPT_INTERFACE_NAME)

      webViewClient =
        object : WebViewClient() {
          override fun shouldOverrideUrlLoading(
            view: WebView?,
            request: WebResourceRequest?,
          ): Boolean {
            val url = request?.url ?: return false
            val policy = coordinator.decidePolicy(url, config.allowed, config.url)
            logger.debug("Loading URL $url: $policy")

            if (policy == NavigationPolicy.CANCEL) {
              coordinator.openInCustomTabs(context, url)
              return true
            }
            return false
          }

          override fun onPageFinished(
            view: WebView?,
            url: String?,
          ) {
            super.onPageFinished(view, url)
            logger.info("Finished loading webview: $url")
            injectUserScripts(this@apply, context, plugins)
          }
        }

      webChromeClient = WebChromeClient()

      setDownloadListener { url, _, _, _, _ ->
        logger.debug("URL $url is a download, opening in Custom Tabs")
        coordinator.openInCustomTabs(context, Uri.parse(url))
      }
    }

  coordinator.webView = webView
  return webView
}

fun injectUserScripts(
  webView: WebView,
  context: Context,
  plugins: Map<String, Plugin>,
  appScriptSource: String? = null,
) {
  val logger = Logger("UserScripts")

  // 1. Inject Bridge Script
  webView.evaluateJavascript(JasonelleBridge.JS_BRIDGE_SCRIPT, null)

  // 2. Inject Plugin scripts
  for ((_, plugin) in plugins) {
    val script = plugin.js()
    if (script.isNotEmpty()) {
      logger.debug("Injecting plugin script for ${plugin.name}")
      webView.evaluateJavascript(script, null)
    }
  }

  // 3. Inject app script (webview.js)
  val appScript =
    appScriptSource ?: try {
      context.assets
        .open("webview.js")
        .bufferedReader()
        .use { it.readText() }
    } catch (_: Exception) {
      null
    }

  if (!appScript.isNullOrEmpty()) {
    logger.debug("Injecting app webview.js script")
    webView.evaluateJavascript(appScript, null)
  }
}

/**
 * Jetpack Compose composable for displaying the Jasonelle WebView.
 */
@Composable
@Suppress("ktlint:standard:function-naming")
fun JasonelleWebView(
  config: AppConfiguration,
  plugins: Map<String, Plugin>,
  modifier: Modifier = Modifier,
) {
  AndroidView(
    modifier = modifier,
    factory = { context ->
      val view = createJasonelleWebView(context, config, plugins)
      view.loadUrl(config.url.toString())
      view
    },
    update = { },
  )
}
