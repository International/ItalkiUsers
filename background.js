// Generated by CoffeeScript 1.3.3
(function() {
  var avatars, deferreds;

  avatars = ["http://www.italki.com/teacher/T008209541.htm", "http://www.italki.com/T010226319.htm"];

  deferreds = avatars.map(function(e) {
    var dfrd;
    dfrd = $.Deferred();
    console.log("requesting " + e);
    $.get(e, function(server_response) {
      var nick;
      nick = $("span.nickname", server_response).html();
      console.log("parsed " + nick);
      return dfrd.resolve(nick);
    });
    return dfrd.promise();
  });

  $.when.apply(this, deferreds).then(function() {
    console.log("AJAX finished");
    return console.log(arguments);
  });

}).call(this);
