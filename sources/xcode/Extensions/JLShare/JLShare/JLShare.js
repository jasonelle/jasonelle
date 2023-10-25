(() => {
    if (window && window.$share) {
        return;
    }
    
    const share = {
        types: {
            text: 0,
            url: 1
        }
    };
    
    // private method
    share.__show = (options = {}) => {
        return $agent.trigger("$share.show", {...{type: share.types.text, value: ""}, ...options});
    };
    
    
    share.text = (value) => {
        return share.__show({type: share.types.text, value});
    };
    
    share.url = (value) => {
        return share.__show({type: share.types.url, value});
    };
    
    // Export
    window.$share = share;
    // window.$jasonelle.share = share;
})();
