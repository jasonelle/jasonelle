 (() => {
     if (window && window.$audio) {
         return;
     }
     
     const $audio = {};
     
     $audio.player = {};
     $audio.session = {};
     $audio.recorder = {};
     
     $audio.player.load = (url, options = {}) => $agent.trigger("$audio.load", {url, options});
     
     $audio.player.pause = (channel = 0) => $agent.trigger("$audio.pause", {channel});
     $audio.player.play = (channel = 0, options = {}) => $agent.trigger("$audio.play", {channel, options})
     
     window.$audio = $audio;
 })();
