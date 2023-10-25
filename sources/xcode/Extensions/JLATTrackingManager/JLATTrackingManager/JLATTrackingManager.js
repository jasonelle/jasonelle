(() => {
    if (window && window.$attracking) {
        return;
    }
    
    const attracking = {};
    attracking.status = async () => $agent.trigger("$attracking.status", {});
    
    
    // Export
    window.$attracking = attracking;
    // window.$jasonelle.attracking = attracking;
})();


