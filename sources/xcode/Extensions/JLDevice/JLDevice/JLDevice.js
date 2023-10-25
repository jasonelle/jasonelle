(() => {
    if (window && window.$device) {
        return;
    }
    
    const device = {};
    device.info = () => $agent.trigger("$device.info", {});
    
    // Export
    window.$device = device;
    // window.$jasonelle.device = device;
})();
