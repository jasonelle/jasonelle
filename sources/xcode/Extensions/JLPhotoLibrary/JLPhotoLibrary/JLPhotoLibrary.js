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
     
     photolibrary.authorize = (showAlert = true) => $agent.trigger("$photolibrary.authorize", {showAlert});
     
     photolibrary.camera = {};
     photolibrary.camera.authorize = (showAlert = true) => $agent.trigger("$photolibrary.camera.authorize", {showAlert});
     
     photolibrary.camera.granted = () => $agent.trigger("$photolibrary.camera.granted");
     
     // Export
     window.$photolibrary = photolibrary;
     // window.$jasonelle.photolibrary = photolibrary;
 })();
