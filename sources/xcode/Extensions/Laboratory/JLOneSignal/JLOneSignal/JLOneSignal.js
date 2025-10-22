(() => {
    if (window && window.$onesignal) {
        return;
    }
    
    const onesignal = {
        sms: {},
        email: {},
        tags: {},
    };
    
    // Onesignal Info dump
    onesignal.info = () => {
        return $agent.trigger("$onesignal.info", {});
    };
    
    // Permissions
    onesignal.disable = () => {
        return $agent.trigger("$onesignal.disable", {});
    };
    
    onesignal.prompt = () => {
        return $agent.trigger("$onesignal.prompt", {});
    };
    
    // External Id (UserID)
    onesignal.login = (external_id) => {
        return $agent.trigger("$onesignal.login", {"external_id": external_id});
    }
    
    onesignal.logout = () => {
        return $agent.trigger("$onesignal.logout", {});
    };
    
    
    // Email
    onesignal.email.add = (email) => {
        return $agent.trigger("$onesignal.email.add", {"email": email});
    };
    
    onesignal.email.remove = (email) => {
        return $agent.trigger("$onesignal.email.remove", {"email": email});
    };
    
    // SMS
    onesignal.sms.add = (sms) => {
        return $agent.trigger("$onesignal.sms.add", {"sms": sms});
    };
    
    onesignal.sms.remove = (sms) => {
        return $agent.trigger("$onesignal.sms.remove", {"sms": sms});
    };
    
    // Tags
    onesignal.tags.get = () => {
        return $agent.trigger("$onesignal.tags.get", {});
    };
    
    // Add many tags (dictionary)
    onesignal.tags.add = (tags) => {
        return $agent.trigger("$onesignal.tags.add", {"tags": tags});
    };
    
    // Add a single tag
    onesignal.tags.set = (key, value) => {
        const tags = {};
        tags[key] = value;
        return onesignal.tags.add(tags);
    };
    
    // Remove many tags (array)
    onesignal.tags.remove = (tags) => {
        return $agent.trigger("$onesignal.tags.remove", {"tags": tags});
    };
    
    // Remove a single key
    onesignal.tags.delete = (key) => {
        const tags = [key];
        return onesignal.tags.remove(tags);
    };
    
    // Events
    const events = {
        notifications: {
            subscription: {
                changed: {
                    name: "$onesignal.events.notifications.subscription.changed",
                        
                    }
                }
            }
    };

    events.notifications.subscription.changed.dispatch = (detail) =>
        document.dispatchEvent(new CustomEvent(events.notifications.subscription.changed.name, { detail, cancelable: true, bubbles: false }));
    
    
    onesignal.events = events;
    
    // Export
    window.$onesignal = onesignal;
    window.jasonelle.onesignal = onesignal;
})();
