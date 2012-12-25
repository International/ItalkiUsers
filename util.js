// Generated by CoffeeScript 1.3.3
(function() {

  this.set_text = function(text) {
    return chrome.browserAction.setBadgeText({
      text: "" + text
    });
  };

  this.show_notification = function(icon, title, text) {
    var notif;
    notif = webkitNotifications.createNotification("icon_16.png", "Pomodorro finished", "Congrats!");
    notif.show();
    return notif;
  };

  this.browser_action_on_click_listener = function(listener) {
    return chrome.browserAction.onClicked.addListener(listener);
  };

}).call(this);