const openURL = __com_jasonelle_bridges_openurl;
const open = (scheme, path) => openURL({ url: `${scheme}:${path}` });

// https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007899
const sms = (path) => open("sms", path);
const email = (path) => open("mailto", path);
const phone = (path) => open("tel", path);
const facetime = (path) => open("facetime", path);

// Allow any app
const app = (url) => openURL({ url });

export default { sms, email, phone, facetime, app };
