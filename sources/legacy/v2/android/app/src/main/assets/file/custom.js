/*
This file is loaded automatically on $webcontainer.
Use it to modify the website with javascript.
*/

console.log("file://custom.js loaded");


console.log("Initializing OneSignal");

const $onesignal = {};

// OneSignal Helper
$onesignal.login = (external_id) => {
  $agent.trigger("onesignal.login", {externalid: external_id});
};

$onesignal.logout = () => {
  $agent.trigger("onesignal.logout");
};
