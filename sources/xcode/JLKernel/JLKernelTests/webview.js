//
//  webview.js
//  JLKernelTests
//
//  Created by Camilo on 05-09-26.
//

// Mock resource for testing the injection of webview.js
// into the main webview. The content is distinctive so tests
// can assert this file (and not a plugin script) was injected last.
(() => {
  console.log("JLKernelTests webview.js injected")
})();