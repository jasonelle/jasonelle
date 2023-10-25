(() => {
    if (window && window.$clipboard) {
        return;
    }
    
    const clipboard = {};
    clipboard.set = (text = "") => $agent.trigger("$clipboard.set", {text});
    
    clipboard.get = () => $agent.trigger("$clipboard.get", {});
    
    // Export
    window.$clipboard = clipboard;
    // window.$jasonelle.clipboard = clipboard;
})();
