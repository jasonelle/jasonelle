 (() => {
     if (window && window.$cookies) {
         return;
     }
     
     const key = "cookies";
     
     const cookies = {};
     
     // Store document.cookie in keychain
     cookies.set = () => {
         const value = document.cookie;
         return $agent.trigger("$keychain.set", {key, value})
     };
     
     // Get cookie value from keychain
     cookies.get = () => {
         return $agent.trigger("$keychain.get", {key})
     };
     
     // Removes cookies value from keychain
     cookies.remove = () => {
         return $agent.trigger("$keychain.remove", {key})
     };
     
     // Write cookie value from keychain to document.cookie
     cookies.write = () => {
         return window.$cookies.get().then(cookies => {
             document.cookie = cookies;
             return document.cookie;
         })
     };
     
     // js-cookie Helper
     cookies.Cookies = Cookies.noConflict();
     
     // Export
     window.$cookies = cookies;
     // window.$jasonelle.cookies = cookies;
 })();
