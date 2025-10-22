 (() => {
     if (window && window.$settings) {
         return;
     }
     
     if (!window.$extensions) {
         window.$extensions = {};
     }
     
     const settings = {};
     
     settings.get = () => {
         return $agent.trigger("$settings.get", {});
     };
     
     // Export
     window.$settings = settings;
     window.$extensions.settings = settings;
     
 })();

