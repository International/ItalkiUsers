poster = $.get "http://www.italki.com",(data) ->
  avatar_loop = $("div.spacing .avater_loop li div a",data)
  for avatar in avatar_loop
    alert $(avatar).attr("href")
poster.error (a,b,c) ->
  alert "Error accessing italki"
