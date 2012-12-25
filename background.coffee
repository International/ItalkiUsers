#poster = $.get "http://www.italki.com",(data) ->
#  avatar_loop = $("div.spacing .avater_loop li div a",data)
#  for avatar in avatar_loop
#    alert $(avatar).attr("href")
#poster.error (a,b,c) ->
#  alert "Error accessing italki"
avatars   = ["http://www.italki.com/teacher/T008209541.htm","http://www.italki.com/T010226319.htm"]
deferreds = avatars.map (e) -> 
  dfrd    = $.Deferred()
  console.log "requesting #{e}"
  $.get e, (server_response) ->
    nick  = $("span.nickname",server_response).html()
    console.log "parsed #{nick}"
    dfrd.resolve(nick)
  dfrd.promise()

$.when.apply(this, deferreds).then ->
  console.log "AJAX finished"
  console.log arguments

#$.get "http://www.italki.com/T010226319.htm",(data) ->
#  alert $("span.nickname",data).html()
#.error (a,b,c) ->
#  alert "Faith error"