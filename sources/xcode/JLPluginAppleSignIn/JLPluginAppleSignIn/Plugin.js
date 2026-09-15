//
//  Plugin.js
//  JLPluginAppleSignIn
//
//  Created by Camilo on 15-09-26.
//

(() => {
  const native = window.jasonelle;
  const plugin = native.plugin.init(
    "applesignin",
    "com.jasonelle.plugins.applesignin"
  );

  // Official Apple logo SVG conforming to Apple Human Interface Guidelines
  const APPLE_LOGO_SVG = `<svg viewBox="0 0 170 170" width="100%" height="100%" aria-hidden="true" focusable="false" style="display:inline-block;vertical-align:middle;overflow:visible;">` +
    `<path fill="currentColor" d="M150.37 130.25c-2.45 5.66-5.35 10.87-8.71 15.66-4.58 6.53-8.33 11.05-11.22 13.56-4.48 4.12-9.28 6.23-14.42 6.35-3.69 0-8.14-1.05-13.32-3.18-5.19-2.12-9.97-3.17-14.34-3.17-4.58 0-9.49 1.05-14.75 3.17-5.26 2.13-9.5 3.24-12.74 3.35-4.35.13-9.16-1.9-14.42-6.08-3.7-3.04-7.58-7.7-11.64-13.99-5.87-9.1-10.4-19.5-13.59-31.21-3.19-11.71-4.78-22.95-4.78-33.72 0-16.14 4.09-29.62 12.27-40.44 8.18-10.82 18.57-16.3 31.18-16.43 5.43 0 11.19 1.34 17.29 4.01 6.1 2.68 10.02 4.07 11.76 4.17 1.63-.1 5.66-1.54 12.09-4.32 6.43-2.78 12.03-4.04 16.8-3.78 12.63.63 22.84 5.39 30.63 14.28-10.89 6.64-16.22 15.77-16 27.38.22 9.07 3.75 16.8 10.6 23.19 6.84 6.39 15.05 10.04 24.63 10.96-2.18 6.65-4.98 13.4-8.41 20.25l-.01.01zM119.22 31.84c0-7.72 2.76-14.89 8.28-21.52 5.53-6.62 12.3-10.32 20.33-11.1 0 .91.06 1.83.06 2.75 0 7.42-2.88 14.74-8.64 21.96-5.76 7.22-12.67 11.08-20.73 11.58-.2-.93-.3-1.84-.3-2.73l-1-.94z"/>` +
    `</svg>`;

  /**
   * Initiates the native Sign In with Apple authorization flow.
   *
   * @param {Object} [options={}]
   * @param {Array<string>} [options.scopes=['fullName', 'email']] - Scopes to request
   * @param {string} [options.nonce] - Cryptographic nonce for replay protection
   * @param {string} [options.state] - Arbitrary state string passed back with response
   * @param {string} [options.user] - Existing user identifier for re-authentication
   * @returns {Promise<Object>} Resolves with user details, identityToken, and authorizationCode
   */
  plugin.signIn = (options = {}) => {
    return native.post(plugin.id, {
      action: "signIn",
      scopes: options.scopes || ["fullName", "email"],
      nonce: options.nonce,
      state: options.state,
      user: options.user,
    });
  };

  /**
   * Queries the credential state of an Apple user identifier.
   *
   * @param {string} userID - The stable Apple user identifier
   * @returns {Promise<{status: string, state: 'authorized'|'revoked'|'notFound'|'transferred'|'unknown'}>}
   */
  plugin.getCredentialState = (userID) => {
    return native.post(plugin.id, {
      action: "getCredentialState",
      userID,
    });
  };

  /**
   * Shows a native UIKit ASAuthorizationAppleIDButton over the window (iOS only).
   *
   * @param {Object} [options={}]
   * @returns {Promise<Object>}
   */
  plugin.showNativeButton = (options = {}) => {
    return native.post(plugin.id, {
      action: "showNativeButton",
      ...options,
    });
  };

  /**
   * Hides the native UIKit button overlay if displayed.
   *
   * @returns {Promise<Object>}
   */
  plugin.hideNativeButton = () => {
    return native.post(plugin.id, { action: "hideNativeButton" });
  };

  /**
   * Resolves the button title text based on the Apple HIG button type.
   */
  const getButtonTitle = (type) => {
    switch (type) {
      case "continue":
        return "Continue with Apple";
      case "signUp":
      case "signup":
        return "Sign up with Apple";
      case "logoOnly":
      case "logo_only":
        return "";
      case "signIn":
      case "signin":
      default:
        return "Sign in with Apple";
    }
  };

  /**
   * Creates a Sign In with Apple button DOM element styled in strict accordance
   * with Apple's Human Interface Guidelines (HIG).
   *
   * @param {Object} [options={}]
   * @param {'signIn'|'continue'|'signUp'|'logoOnly'} [options.type='signIn'] - Button type
   * @param {'black'|'white'|'white-outline'} [options.style='black'] - Visual style
   * @param {number|string} [options.borderRadius=8] - Corner radius in px or CSS string
   * @param {number|string} [options.height=44] - Height in px (minimum 44px recommended by HIG)
   * @param {string} [options.width='100%'] - Width (e.g. '100%', '240px')
   * @param {Array<string>} [options.scopes=['fullName', 'email']] - Authorization scopes
   * @param {string} [options.nonce] - Nonce
   * @param {string} [options.state] - State
   * @param {function(Object):void} [options.onSuccess] - Callback on successful authorization
   * @param {function(Object):void} [options.onError] - Callback on authorization error
   * @returns {HTMLButtonElement} Configured button element
   */
  plugin.createButton = (options = {}) => {
    const type = options.type || "signIn";
    const style = options.style || "black";
    const title = getButtonTitle(type);
    const height = typeof options.height === "number" ? `${options.height}px` : (options.height || "44px");
    const width = typeof options.width === "number" ? `${options.width}px` : (options.width || "100%");
    const borderRadius = typeof options.borderRadius === "number" ? `${options.borderRadius}px` : (options.borderRadius || "8px");

    const button = document.createElement("button");
    button.type = "button";
    button.className = `apple-sign-in-button apple-sign-in-${style} ${options.className || ""}`.trim();
    button.setAttribute("role", "button");
    button.setAttribute("aria-label", title || "Sign in with Apple");

    // Colors matching HIG specifications
    let bgColor = "#000000";
    let textColor = "#FFFFFF";
    let borderStyle = "none";

    if (style === "white") {
      bgColor = "#FFFFFF";
      textColor = "#000000";
      borderStyle = "none";
    } else if (style === "white-outline" || style === "whiteOutline") {
      bgColor = "#FFFFFF";
      textColor = "#000000";
      borderStyle = "1px solid #000000";
    }

    // Base button styling according to Apple HIG
    Object.assign(button.style, {
      display: "inline-flex",
      alignItems: "center",
      justifyContent: "center",
      boxSizing: "border-box",
      width: width,
      minHeight: "44px",
      height: height,
      padding: "0 16px",
      backgroundColor: bgColor,
      color: textColor,
      border: borderStyle,
      borderRadius: borderRadius,
      fontFamily: '-apple-system, BlinkMacSystemFont, "SF Pro Text", "SF Pro Display", "Helvetica Neue", Helvetica, Arial, sans-serif',
      fontSize: "17px",
      fontWeight: "500",
      lineHeight: "1",
      letterSpacing: "-0.4px",
      cursor: "pointer",
      userSelect: "none",
      WebkitUserSelect: "none",
      touchAction: "manipulation",
      transition: "opacity 0.15s ease, transform 0.05s ease",
      outline: "none",
      textDecoration: "none",
    });

    // Logo icon wrapper
    const iconWrapper = document.createElement("span");
    Object.assign(iconWrapper.style, {
      display: "inline-block",
      width: "16px",
      height: "20px",
      marginRight: title ? "8px" : "0",
      flexShrink: "0",
      color: textColor,
    });
    iconWrapper.innerHTML = APPLE_LOGO_SVG;
    button.appendChild(iconWrapper);

    // Text label
    if (title) {
      const label = document.createElement("span");
      label.textContent = title;
      Object.assign(label.style, {
        display: "inline-block",
        whiteSpace: "nowrap",
      });
      button.appendChild(label);
    }

    // Interactive states (touch/hover/active)
    button.addEventListener("mouseenter", () => {
      button.style.opacity = "0.88";
    });
    button.addEventListener("mouseleave", () => {
      button.style.opacity = "1.0";
    });
    button.addEventListener("mousedown", () => {
      button.style.transform = "scale(0.99)";
      button.style.opacity = "0.75";
    });
    button.addEventListener("mouseup", () => {
      button.style.transform = "scale(1.0)";
      button.style.opacity = "0.88";
    });

    // Tap/Click handler initiating authorization
    button.addEventListener("click", async (e) => {
      e.preventDefault();
      if (button.disabled) return;

      button.disabled = true;
      button.style.opacity = "0.6";

      try {
        const result = await plugin.signIn({
          scopes: options.scopes || ["fullName", "email"],
          nonce: options.nonce,
          state: options.state,
          user: options.user,
        });

        if (typeof options.onSuccess === "function") {
          options.onSuccess(result);
        }

        button.dispatchEvent(
          new CustomEvent("applesignin:success", {
            detail: result,
            bubbles: true,
          })
        );
      } catch (error) {
        if (typeof options.onError === "function") {
          options.onError(error);
        }

        button.dispatchEvent(
          new CustomEvent("applesignin:error", {
            detail: error,
            bubbles: true,
          })
        );
      } finally {
        button.disabled = false;
        button.style.opacity = "1.0";
      }
    });

    return button;
  };

  /**
   * Creates and attaches a Sign In with Apple button into a target container.
   *
   * @param {HTMLElement|string} target - Container element or CSS selector
   * @param {Object} [options={}] - Options passed to plugin.createButton
   * @returns {HTMLButtonElement|null} The created button element
   */
  plugin.renderButton = (target, options = {}) => {
    const container = typeof target === "string" ? document.querySelector(target) : target;
    if (!container) {
      console.warn("JLPluginAppleSignIn: Target container not found for renderButton", target);
      return null;
    }

    if (options.replace !== false) {
      container.innerHTML = "";
    }

    const button = plugin.createButton(options);
    container.appendChild(button);
    return button;
  };

  // Register on window.jasonelle.plugins
  window.jasonelle.plugins.applesignin = plugin;
})();
