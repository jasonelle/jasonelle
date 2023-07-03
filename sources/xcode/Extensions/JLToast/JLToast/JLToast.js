(() => {
    if (window && window.$toast) {
        return;
    }
    
    const toast = {};
    toast.options = {
        type: {
          "default": 0,
          "dark": 1,
          "error": 2,
          "success": 3,
          "warning": 4,
          "info": 5
        },
        position: {
            bottom: 0,
            center: 1,
            top: 2
        }
    };
    
    toast.show = (text, options = {type: 0, position: 0, duration: 3.0}) => {
        return $agent.trigger("$toast.show", {text, options});
    };
    
    toast.dark = (text, options = {position: 0, duration: 3.0}) => {
        return toast.show(text, {...{type: 1}, ...options});
    };
    
    toast.error = (text, options = {position: 0, duration: 3.0}) => {
        return toast.show(text, {...{type: 2}, ...options});
    };
    
    toast.success = (text, options = {position: 0, duration: 3.0}) => {
        return toast.show(text, {...{type: 3}, ...options});
    };
    
    toast.warning = (text, options = {position: 0, duration: 3.0}) => {
        return toast.show(text, {...{type: 4}, ...options});
    };
    
    toast.info = (text, options = {position: 0, duration: 3.0}) => {
        return toast.show(text, {...{type: 5}, ...options});
    };
    
    toast.banner = {};
    toast.banner.options = {
        type: {
         "success": 0,
         "error": 1,
         "info": 2
        }
    };
    
    toast.banner.show = (text, options = {type: 0}) => {
        return $agent.trigger("$toast.banner.show", {text, options});
    };
    
    toast.loading = {};
    
    toast.loading.show = (options = {}) => {
        return $agent.trigger("$toast.loading.show", options);
    };
    
    toast.loading.hide = (options = {}) => {
        return $agent.trigger("$toast.loading.hide", options);
    };
    
    window.$toast = toast;
    window.$jasonelle.toast = toast;
})();
