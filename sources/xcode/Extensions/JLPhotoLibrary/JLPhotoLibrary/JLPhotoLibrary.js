 (() => {
     if (!window || window.$photolibrary) {
         return true;
     }
     
     const photolibrary = {
         status: {
            notdetemined: 0,
            restricted: 1,
            denied: 2,
            authorized: 3,
            limited: 4
         }
     };
     
     photolibrary.granted = () => $agent.trigger("$photolibrary.granted");
     
     // Do not prompt an alert if showAlert = true or it will crash since
     // We cannot know yet if the alert was dismissed. before showing a new one.
     photolibrary.authorize = (showAlert = false) => $agent.trigger("$photolibrary.authorize").then(status => {
             if (status == photolibrary.status.denied && showAlert) {
                 return $agent.trigger("$photolibrary.alert");
             }
             return Promise.resolve(status);
     });
     
     window.$photolibrary = photolibrary;
 })();
