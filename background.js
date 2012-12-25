// Generated by CoffeeScript 1.3.3
(function() {
  var failure, get_italki_online_users, millis_to_persist_notifications, seconds_to_persist_notifs, success;

  seconds_to_persist_notifs = 30;

  millis_to_persist_notifications = seconds_to_persist_notifs * 1000;

  get_italki_online_users = function() {
    return $.Deferred(function(dfd) {
      return $.get("http://www.italki.com", function(data) {
        var avatar_loop;
        avatar_loop = $("div.spacing .avater_loop li div a", data);
        if (avatar_loop.length > 0) {
          return dfd.resolve(avatar_loop);
        } else {
          return dfd.reject();
        }
      });
    }).promise();
  };

  success = function(online_users) {
    var deferreds, dfrd, profile, profile_addresses, _i, _len;
    console.log(online_users);
    profile_addresses = online_users.map(function(i, e) {
      return $(e).attr("href");
    });
    deferreds = [];
    for (_i = 0, _len = profile_addresses.length; _i < _len; _i++) {
      profile = profile_addresses[_i];
      dfrd = $.Deferred();
      $.get(profile, function(server_response) {
        var nick;
        nick = $("span.nickname", server_response).html();
        return dfrd.resolve(nick);
      });
      deferreds.push(dfrd.promise());
    }
    return $.when.apply(this, deferreds).done(function() {
      var argument, notif, _j, _len1;
      console.log("arguments");
      online_users = [];
      for (_j = 0, _len1 = arguments.length; _j < _len1; _j++) {
        argument = arguments[_j];
        online_users.push(argument);
      }
      online_users = online_users.join(",");
      notif = show_notification(null, "Online users", online_users);
      return setTimeout((function() {
        return notif.cancel();
      }), millis_to_persist_notifications);
    });
  };

  failure = function() {
    var notif;
    notif = show_notification(null, ":(", "No users online");
    return setTimeout((function() {
      return notif.cancel();
    }), millis_to_persist_notifications);
  };

  $.when(get_italki_online_users()).then(success, failure);

}).call(this);
