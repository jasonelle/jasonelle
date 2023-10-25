(() => {
    if (window && window.$myextension) {
        return;
    }
    
    // Creates a Wrapper to Ease calling
    // $myextension.run().then(message => {
    //      $logger.trace(message);
    // });
    
    const myextension = {};
    
    myextension.run = () => $agent.trigger("$myextension.run");
    
    // Define the events that would be called in Handlers
    // To notify webview of certain workflows
    const events = {
        example: {
            name: "$myextension.events.example"
        }
    };
    
    // Dispatch a new custom event
    // https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent/CustomEvent
    events.example.dispatch = (detail) => document.dispatchEvent(new CustomEvent(events.example.name, { detail, cancelable: true, bubbles: false }));
    
    myextension.events = events;
    
    // Export
    window.$myextension = myextension;
    // window.$jasonelle.myextension = myextension;
})();
