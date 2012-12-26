# how many seconds to wait before cancelling notifications
seconds_to_persist_notifs       = 60

# time in milliseconds, since JS setTimeout works with them
millis_to_persist_notifications = seconds_to_persist_notifs * 1000

# how much time to wait between checks, by default 5 minutes 
default_check_interval          = 60 * 5 * 1000

sound_notif = (what,tts=true) ->
  if tts
    chrome.tts.speak(what)
  else
    document.getElementById("audio_file").play()

create_cancellable_notification = (title,text,millis) ->
  notif = show_notification(null, title, text)
  setTimeout (-> notif.cancel()),millis

success = ->
  console.log "Have #{arguments.length} users"
  online_users = []
  for user in arguments
    online_users.push(user)

  online_users = online_users.join(",")
  create_cancellable_notification("Online users",online_users, millis_to_persist_notifications)
  sound_notif(online_users, false)
 
failure = ->
  create_cancellable_notification("Could not resolve users","Error resolving", millis_to_persist_notifications)

italki_checker = ->
  $.get "http://www.italki.com",(data) ->
    avatar_loop = $("div.spacing .avater_loop li div a",data)
    console.log "Avatars: #{avatar_loop.length}"
    if avatar_loop.length > 0
      profiles  = []
      deferreds = []
      for user in avatar_loop
        $.Deferred (dfrd) ->
          $.get $(user).attr("href"), (server_response) ->
            nick = $("span.nickname", server_response).html()
            dfrd.resolve(nick)
          deferreds.push(dfrd.promise())
      $.when.apply(this, deferreds).then(success,failure).done ->
        setTimeout italki_checker, default_check_interval
    else
      create_cancellable_notification(":(","No online users",millis_to_persist_notifications)

italki_checker()
