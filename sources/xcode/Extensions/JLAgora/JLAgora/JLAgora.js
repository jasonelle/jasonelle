(() => {
    if (window && window.$agora) {
        return;
    }
    
    const agora = {};
    
    agora.start = (appId, token, channel) => $agent.trigger("$agora.start", {appId, token, channel});
    
    window.$agora = agora;
})();
