(() => {
    if (window && window.$attracking) {
        return;
    }
    
    if (!window.$extensions) {
        window.$extensions = {};
    }
    
    const attracking = {};
    attracking.status = async () => $agent.trigger("$attracking.status", {});
    
    
    // Export
    window.$attracking = attracking;
    window.$extensions.attracking = attracking;
})();


