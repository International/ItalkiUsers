seconds_to_persist_notifs       = 30
millis_to_persist_notifications = seconds_to_persist_notifs * 1000

get_italki_online_users = ->
  $.Deferred (dfd) ->
    $.get "http://www.italki.com",(data) ->
      avatar_loop = $("div.spacing .avater_loop li div a",data)
      if avatar_loop.length > 0
        dfd.resolve(avatar_loop)
      else
        dfd.reject()
  .promise()
    
success   = (online_users) ->
  console.log online_users
  profile_addresses = online_users.map (i,e) -> $(e).attr("href")
    
  deferreds = []
  for profile in profile_addresses
    dfrd    = $.Deferred()
    $.get profile, (server_response) ->
      nick  = $("span.nickname",server_response).html()
      dfrd.resolve(nick)
    deferreds.push(dfrd.promise())

  $.when.apply(this, deferreds).done ->
    console.log "arguments"
    online_users = []
    for argument in arguments
      online_users.push(argument)
    online_users = online_users.join(",")
    notif = show_notification(null,"Online users",online_users)
    setTimeout (-> notif.cancel()), millis_to_persist_notifications

failure = ->
  notif = show_notification(null,":(","No users online")
  setTimeout (-> notif.cancel()),millis_to_persist_notifications

$.when(get_italki_online_users()).then success,failure

#poster = $.get "http://www.italki.com",(data) ->
#  avatar_loop = $("div.spacing .avater_loop li div a",data)
#  for avatar in avatar_loop
#    alert $(avatar).attr("href")
#poster.error (a,b,c) ->
#  alert "Error accessing italki"
# avatars   = ["http://www.italki.com/teacher/T008209541.htm","http://www.italki.com/T010226319.htm"]
#deferreds = avatars.map (e) -> 
#  dfrd    = $.Deferred()
#  console.log "requesting #{e}"
#  $.get e, (server_response) ->
#    nick  = $("span.nickname",server_response).html()
#    console.log "parsed #{nick}"
#    dfrd.resolve(nick)
#  dfrd.promise()
#
#$.when.apply(this, deferreds).then ->
#  console.log "AJAX finished"
#  console.log arguments

#$.get "http://www.italki.com/T010226319.htm",(data) ->
#  alert $("span.nickname",data).html()
#.error (a,b,c) ->
#  alert "Faith error"
