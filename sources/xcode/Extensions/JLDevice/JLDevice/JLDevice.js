(() => {
    if (window && window.$device) {
        return;
    }
    
    if (!window.$extensions) {
        window.$extensions = {};
    }
    
    const device = {};
    device.info = () => $agent.trigger("$device.info", {});
    
    // Export
    window.$device = device;
    window.$extensions.device = device;
})();
