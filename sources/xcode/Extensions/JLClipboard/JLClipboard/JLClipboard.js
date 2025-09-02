(() => {
    if (window && window.$clipboard) {
        return;
    }
    
    if (!window.$extensions) {
        window.$extensions = {};
    }
    
    const clipboard = {};
    clipboard.set = (text = "") => $agent.trigger("$clipboard.set", {text});
    
    clipboard.get = () => $agent.trigger("$clipboard.get", {});
    
    // Export
    window.$clipboard = clipboard;
    window.$extensions.clipboard = clipboard;
})();
