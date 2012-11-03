$(document).ready(function() {
  var track_actions = true;

  $('.track').hover(function() {
    $(this).find('img').addClass('hover');
    $(this).find('.track-play').show();
  }, function() {
    $(this).find('img').removeClass('hover');
    $(this).find('.track-play').hide();
  });

  var track_id = $('.player').attr('track-id');
  if(typeof track_id === 'undefined') return false;

  var player = undefined;
  var loading = true;
  var loaded = false;

  SC.initialize({
    client_id: 'e3216af75bcd70ee4e5d91a6b9f1d302'
  });
  SC.stream("/tracks/"+track_id, {
    autoPlay: true,
    useHTML5Audio: true,
    ontimedcomments: function(){},
    onplay: function(){},
    onerror: function(){
      if(track_actions) {
        mixpanel.track("error playing track", {"track": track_id});
      }

      var href = $('.player').attr('next-track');
      window.location = href;
    },
    onfinish: function() {
      if(track_actions) {
        mixpanel.track("track finished", {
          "elapsed": $('#player-elapsed').html(),
          "duration": $('#player-duration').html()
        });
      }

      var href = $('.player').attr('next-track');
      window.location = href;
    }
  }, function(s) {
    player = s;

    loading = false;
    loaded = true;
  });

  setInterval(function() {
    if(loading || !loaded) return false;

    var sound = player;

    // Elapsed time
    var position = sound.position;
    var duration_est = sound.durationEstimate;

    var loaded_ratio = position / duration_est;
    var seek_width = loaded_ratio * 100;

    $('#player-elapsed').html(to_time(position));
    $('#player-duration').html(to_time(duration_est));
    $('#player-progress-bar-meter').css('width', seek_width+'%');
  }, 500);

  // Event Listeners

  $('#player-play').click(function() {
    if(loading) return false;

    player.play();

    $('#player-pause').css('display', 'inline-block');
    $('#player-play').hide();

    if(track_actions) {
      mixpanel.track("play control click", {
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
  });

  $('#player-pause').click(function() {
    if(loading) return false;

    player.pause();

    $('#player-play').css('display', 'inline-block');
    $('#player-pause').hide();

    if(track_actions) {
      mixpanel.track("pause control click", {
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
  });

  $('#player-seek').click(function(e) {
    if(loading) return false;

    var x = e.offsetX;
    var seek_width = $('#player-seek').width();
    var per_seek = (x/seek_width);

    var sound = player;
    sound.setPosition(per_seek * sound.durationEstimate);

    if(track_actions) {
      mixpanel.track("seek bar click", {
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
  });

  $('#player-volume-up').click(function() {
    if(loading) return false;

    player.mute();

    $('#player-volume-up').hide();
    $('#player-volume-off').show();

    if(track_actions) {
      mixpanel.track("mute track", {
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
  });

  $('#player-volume-off').click(function() {
    if(loading) return false;

    player.unmute();

    $('#player-volume-up').show();
    $('#player-volume-off').hide();

    if(track_actions) {
      mixpanel.track("unmute track", {
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
  });

  function to_time(time) {
    var total_seconds = Math.floor(time / 1000);

    var minutes = Math.floor(total_seconds / 60);
    var seconds = total_seconds % 60;

    if(minutes < 10) {
      minutes = '0'+minutes;
    }

    if(seconds < 10) {
      seconds = '0'+seconds;
    }

    return minutes+':'+seconds
  }
});
