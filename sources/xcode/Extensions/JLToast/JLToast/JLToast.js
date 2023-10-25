(() => {
    if (window && window.$toast) {
        return;
    }
    
    const toast = {};
    toast.options = {
        type: {
          default: 0,
          dark: 1,
          error: 2,
          success: 3,
          warning: 4,
          info: 5
        },
        position: {
            bottom: 0,
            center: 1,
            top: 2
        }
    };
    
    // Toast
    toast.show = (text, options = {}) => {
        return $agent.trigger("$toast.show", {text, options: {...{type: 0, position: 0, duration: 3.0}, ...options}});
    };
    
    toast.dark = (text, options = {}) => {
        return toast.show(text, {...options, ...{type: 1}});
    };
    
    toast.error = (text, options = {}) => {
        return toast.show(text, {...options, ...{type: 2}});
    };
    
    toast.success = (text, options = {}) => {
        return toast.show(text, {...options, ...{type: 3}});
    };
    
    toast.warning = (text, options = {}) => {
        return toast.show(text, {...options, ...{type: 4}});
    };
    
    toast.info = (text, options = {}) => {
        return toast.show(text, {...options, ...{type: 5}});
    };
    
    // Banner
    toast.banner = {};
    toast.banner.show = (text, options = {}) => {
        return $agent.trigger("$toast.banner.show", {text, options: {...{type: 0, duration: 3.0}, ...options}
        });
    };
    
    
    toast.banner.dark = (text, options = {}) => {
        return toast.banner.show(text, {...options, ...{type: 1}});
    };
    
    toast.banner.error = (text, options = {}) => {
        return toast.banner.show(text, {...options, ...{type: 2}});
    };
    
    toast.banner.success = (text, options = {}) => {
        return toast.banner.show(text, {...options, ...{type: 3}});
    };
    
    toast.banner.warning = (text, options = {}) => {
        return toast.banner.show(text, {...options, ...{type: 4}});
    };
    
    toast.banner.info = (text, options = {}) => {
        return toast.banner.show(text, {...options, ...{type: 5}});
    };
                            
    
    toast.loading = {};
    
    toast.loading.show = (options = {}) => {
        return $agent.trigger("$toast.loading.show", options);
    };
    
    toast.loading.hide = (options = {}) => {
        return $agent.trigger("$toast.loading.hide", options);
    };
    
    window.$toast = toast;
    // window.$jasonelle.toast = toast;
})();
