 (() => {
     if (window && window.$audio) {
         return;
     }
     
     // Init
     const $audio = {};
     const events = {
         recorder: {
             status: {
                 event: "$audio.events.recorder.status"
             },
             finished: {
                 event: "$audio.events.recorder.finished"
             },
             error: {
                 event: "$audio.events.recorder.error"
             }
         },
         player: {}
     };
     
     // Session
     // TODO: Maybe add AVAudioSession config?
     $audio.session = {};
     
     // Record
     $audio.recorder = {};
     
     // Events
     events.recorder.status.dispatch = (detail = {}) => document.dispatchEvent(new CustomEvent(events.recorder.status.event, { detail, cancelable: true, bubbles: false }));
     
     events.recorder.finished.dispatch = (detail = {}) => document.dispatchEvent(new CustomEvent(events.recorder.finished.event, { detail, cancelable: true, bubbles: false }));
     
     events.recorder.error.dispatch = (detail = {}) => document.dispatchEvent(new CustomEvent(events.recorder.error.event, { detail, cancelable: true, bubbles: false }));
     
     // Actions
     $audio.recorder.authorize = () => $agent.trigger("$audio.recorder.authorize", {});
     
     $audio.recorder.record = (options = {}) => $agent.trigger("$audio.recorder.record", options);
     
     $audio.recorder.pause = () => $agent.trigger("$audio.recorder.pause", {});
     
     $audio.recorder.stop = () => $agent.trigger("$audio.recorder.stop", {});
     
     $audio.recorder.resume = () => $agent.trigger("$audio.recorder.resume", {});
     
     
     // Player
     $audio.player = {};
     
     $audio.player.load = (url, options = {}) => $agent.trigger("$audio.player.load", {url, options});
     
     $audio.player.pause = (channel = 0) => $agent.trigger("$audio.player.pause", {channel});
     $audio.player.play = (channel = 0, options = {}) => $agent.trigger("$audio.player.play", {channel, options});
     
     // Vibrate
     $audio.vibrate = () => $agent.trigger("$audio.vibrate", {});
     
     $audio.events = events;
     
     // Export
     window.$audio = $audio;
     // window.$jasonelle.audio = $audio;
 })();
