 (() => {
     if (window && window.$reachability) {
         return;
     }
     
     const reachability = {
         // Apple NetworkStatus Compatible Names.
         status: {
             not_reachable: 0,
             wwan_reachable: 1,
             cellular_reachable: 1, // the same as wwan, just to have ubiquotus language
             wifi_reachable: 2
         },
         status_names: {
            0: "No Connection",
            1: "Cellular",
            2: "Wifi"
         }
     };

     // Helper functions

     reachability.is_wifi = (event) => event.detail.status == reachability.status.wifi_reachable;
     
     reachability.is_cellular = (event) => event.detail.status == reachability.status.wwan_reachable;
     
     reachability.to_string = (status) => reachability.status_names[status];

     reachability.reachable = (event) => event.detail.reachable;

     reachability.is_reachable = (event, only = "all") => {

         if (reachability.reachable(event)) {
             if (only == "all") {
                 return true;
             }

             if (only == reachability.status.wifi_reachable) {
                 return reachability.is_wifi(event);
             }

             if (only == reachability.status.wwan_reachable) {
                 return reachability.is_cellular(event);
             }
         }

         return false;
     };
     
     // Action triggers
     reachability.get = () => $agent.trigger("$reachability.get");


     const events = {
         changed: {
            name: "$reachability.events.changed",
         }
     };

     // Events
     events.changed.dispatch = (detail) =>
         document.dispatchEvent(new CustomEvent(events.changed.name, { detail, cancelable: true, bubbles: false }));
     
     
     reachability.events = events;

     // Export
     window.$reachability = reachability;
     // window.$jasonelle.reachability = reachability;
})();
