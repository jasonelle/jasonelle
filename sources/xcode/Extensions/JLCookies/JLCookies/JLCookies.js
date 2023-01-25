 (() => {
     if (window && window.$cookies) {
         return;
     }
     
     const key = "cookies";
     
     window.$cookies = {};
     
     // Store document.cookie in keychain
     window.$cookies.set = () => {
         const value = document.cookie;
         return $agent.trigger("$keychain.set", {key, value})
     };
     
     // Get cookie value from keychain
     window.$cookies.get = () => {
         return $agent.trigger("$keychain.get", {key})
     };
     
     // Removes cookies value from keychain
     window.$cookies.remove = () => {
         return $agent.trigger("$keychain.remove", {key})
     };
     
     // Write cookie value from keychain to document.cookie
     window.$cookies.write = () => {
         return window.$cookies.get().then(cookies => {
             document.cookie = cookies;
             return document.cookie;
         })
     };
     
     // js-cookie Helper
     window.$cookies.Cookies = Cookies.noConflict();
 })();
