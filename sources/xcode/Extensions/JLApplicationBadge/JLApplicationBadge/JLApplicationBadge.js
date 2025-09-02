(() => {
    if (window && window.$badge) {
        return;
    }
    
    if (!window.$extensions) {
        window.$extensions = {};
    }
    
    const badge = {};
    badge.set = async (number) => $agent.trigger("$badge.set", number);
    
    badge.clear = async () => $agent.trigger("$badge.clear");
    
    // Export
    window.$badge = badge;
    window.$extensions.badge = badge;
})();

