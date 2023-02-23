(() => {
    if (window && window.$myextension) {
        return;
    }
    
    // Creates a Wrapper to Ease calling
    // $myextension.run().then(message => {
    //      $logger.trace(message);
    // });
    
    window.$myextension = {};
    window.$myextension.run = () => $agent.trigger("$myextension.run");
    
    window.$myextension.events = {
        names: {
            example: "com.jasonelle.myextension.event.example"
        }
    };
    window.$myextension.events.example = (detail) => document.dispatchEvent(new CustomEvent(window.$myextension.events.names.example, { detail, cancelable: true, bubbles: false }));
})();
