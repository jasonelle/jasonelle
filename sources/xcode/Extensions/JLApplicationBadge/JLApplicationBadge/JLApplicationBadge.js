(() => {
    if (window && window.$badge) {
        return;
    }
    
    const badge = {};
    badge.set = async (number) => $agent.trigger("$badge.set", number);
    
    badge.clear = async () => $agent.trigger("$badge.clear");
    
    window.$badge = badge;
})();

