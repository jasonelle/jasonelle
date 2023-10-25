// Just a wrapper with functions to ease the keychain access
(() => {
    if (window && window.$keychain) {
        return;
    }
    
    const keychain = {};

    keychain.set = (key, value) => {
        return $agent.trigger("$keychain.set", {key, value});
    }

    keychain.get = (key) => {
        return $agent.trigger("$keychain.get", {key});
    }

    keychain.remove = (key) => {
        return $agent.trigger("$keychain.remove", {key});
    }

    keychain.clear = () => {
        return $agent.trigger("$keychain.clear", {});
    }
    
    // Export
    window.$keychain = keychain;
    // window.$jasonelle.keychain = keychain;
})();
