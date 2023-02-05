// Just a wrapper with functions to ease the keychain access
(() => {
    if (window && window.$keychain) {
        return;
    }
    
    window.$keychain = {};

    window.$keychain.set = (key, value) => {
        return $agent.trigger("$keychain.set", {key, value});
    }

    window.$keychain.get = (key) => {
        return $agent.trigger("$keychain.get", {key});
    }

    window.$keychain.remove = (key) => {
        return $agent.trigger("$keychain.remove", {key});
    }

    window.$keychain.clear = () => {
        return $agent.trigger("$keychain.clear", {});
    }
})();
