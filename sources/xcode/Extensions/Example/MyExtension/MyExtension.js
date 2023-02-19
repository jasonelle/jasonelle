(() => {
    if (window && window.$myextension) {
        return;
    }
    
    // Creates a Wrapper to Ease calling
    // $myextension.run().then(message => {
    //      $logger.trace(message);
    // });
    
    window.$myextension = {};
    window.$myextension.run = () => $agent.trigger("$myextension.run", {});
})();
