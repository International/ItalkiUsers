# how many seconds to wait before cancelling notifications
seconds_to_persist_notifs       = 30

# time in milliseconds, since JS setTimeout works with them
millis_to_persist_notifications = seconds_to_persist_notifs * 1000

# how much time to wait between checks, by default 5 minutes 
default_check_interval          = 60 * 5 * 1000

# finds online italki users, and returns the container for them, so
# that subsequent ajax requests can parse nicknames
# This returns a promise, that can be waited upon
get_italki_online_users = ->
  $.Deferred (dfd) ->
    # try to find the avatar container, and if users are online
    # we resolve the promise, triggering the success callback
    # else we reject it, and go in the failure callback
    $.get "http://www.italki.com",(data) ->
      avatar_loop = $("div.spacing .avater_loop li div a",data)
      if avatar_loop.length > 0
        dfd.resolve(avatar_loop)
      else
        dfd.reject()
  .promise()
    
# this gets called if there are users online, and will proceed
# to parse the nicknames with subsequent ajax calls
# @param online_users [jQuery object]
success   = (online_users) ->
  # extract the urls to the profiles
  profile_addresses = online_users.map (i,e) -> $(e).attr("href")
    
  deferreds = []
  # for each profile, we do an ajax call to retrieve the nickname
  # the ajax requests are encapsulated in jQuery deferred objects
  # and will not move on until the promises are resolved or rejected
  for profile in profile_addresses
    dfrd    = $.Deferred()
    $.get profile, (server_response) ->
      nick  = $("span.nickname",server_response).html()
      dfrd.resolve(nick)
    deferreds.push(dfrd.promise())

  # upon succesful resolution of all the profiles, we show
  # the notification of which users are currently online
  $.when.apply(this, deferreds).done ->
    online_users = []
    for argument in arguments
      online_users.push(argument)
    online_users = online_users.join(",")
    notif = show_notification(null,"Online users",online_users)
    setTimeout (-> notif.cancel()), millis_to_persist_notifications
    setTimeout(check_italki_users, default_check_interval)

# this gets triggered if no users are online
failure = ->
  notif = show_notification(null,":(","No users online")
  setTimeout (-> notif.cancel()),millis_to_persist_notifications
  setTimeout(check_italki_users, default_check_interval)

# main extension function, auto queues itself to run
check_italki_users = ->
  console.log "Checking at:#{new Date().toString()}"
  $.when(get_italki_online_users()).then success,failure

check_italki_users()
