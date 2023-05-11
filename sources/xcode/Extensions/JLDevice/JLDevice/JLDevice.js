(() => {
    if (window && window.$device) {
        return;
    }
    
    window.$device = {};
    window.$device.info = () => $agent.trigger("$device.info", {});
})();
