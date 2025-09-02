(() => {
     if (window && window.$contacts) {
         return;
     }

    if (!window.$extensions) {
        window.$extensions = {};
    }
 
     const contacts = {};
     
     contacts.all = () => $agent.trigger("$contacts.all");
     
     contacts.authorize = () => $agent.trigger("$contacts.authorize");
     
     // Export
     window.$contacts = contacts;
     window.$extensions.contacts = contacts;
})();
