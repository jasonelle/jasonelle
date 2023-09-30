(() => {
    if (window && window.$onesignal) {
        return;
    }
    
    const onesignal = {};
    
    onesignal.get = () => {
        return $agent.trigger("$onesignal.get", {});
    };
    
    // Export
    window.$onesignal = onesignal;
    window.$jasonelle.onesignal = onesignal;
})();
