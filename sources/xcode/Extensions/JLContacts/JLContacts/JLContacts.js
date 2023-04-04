 (() => {
     if (window && window.$contacts) {
         return;
     }
     
     window.$contacts = {};
     window.$contacts.all = () => $agent.trigger("$contacts.all");
     window.$contacts.authorize = () => $agent.trigger("$contacts.authorize");
 })();
