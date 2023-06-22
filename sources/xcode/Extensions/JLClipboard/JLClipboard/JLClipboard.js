(() => {
    if (window && window.$clipboard) {
        return;
    }
    
    window.$clipboard = {};
    window.$clipboard.set = (text = "") => $agent.trigger("$clipboard.set", {text});
    
    window.$clipboard.get = () => $agent.trigger("$clipboard.get", {});
})();
