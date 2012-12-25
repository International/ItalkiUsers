# Sets the badge text
# @param text [String] string to set on the badge
@set_text = (text) ->
  chrome.browserAction.setBadgeText({text: "#{text}"})

# Shows a notification
# @param icon  [String] path to the resource the should be used
# @param title [String] title of the window
# @param text  [String] message shown in the window
@show_notification = (icon, title, text) ->
  notif = webkitNotifications.createNotification(icon, title, text)
  notif.show()
  notif

# Sets a click listener on the icon
# @param listener [Function] handler for the click event
@browser_action_on_click_listener = (listener) ->
  chrome.browserAction.onClicked.addListener(listener)
