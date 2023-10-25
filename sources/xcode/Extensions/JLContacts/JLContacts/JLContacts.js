(() => {
 if (window && window.$contacts) {
     return;
 }
 
 
 const contacts = {};
 
 contacts.all = () => $agent.trigger("$contacts.all");
 
 contacts.authorize = () => $agent.trigger("$contacts.authorize");
 
 // Export
 window.$contacts = contacts;
 // window.$jasonelle.contacts = contacts;
})();
