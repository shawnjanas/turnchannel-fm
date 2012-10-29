$(document).ready(function() {
  var track_actions = false;

  $('.track').hover(function() {
    $(this).find('img').addClass('hover');
  }, function() {
    $(this).find('img').removeClass('hover');
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
    ontimedcomments: this._ontimedcomments,
    onplay: this._onplay,
    onerror: this._onerror,
    onfinish: function() {
      var href = $('#player-step-forward a').attr('href');
      console.log(href);
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

  // Player Controls
  $('#player-step-forward').click(function() {
    //if(player.loading) return false;

    //window.location = $('.player').attr('track-next');

    /*player.nextTrack(function(err, track) {
      $('.playlist-tracks-content .playing').removeClass('playing');
      $('.playlist-tracks-content .track[track-id="'+track.sc_id+'"]').addClass('playing');
    });*/

    // Mixpanel
    if(track_actions) {
      mixpanel.track("next track click", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
  });

  $('#player-step-backward').click(function() {
    //if(player.loading) return false;

    //window.location = $('.player').attr('track-pre');

    /*player.preTrack(function(err, track) {
      $('.playlist-tracks-content .playing').removeClass('playing');
      $('.playlist-tracks-content .track[track-id="'+track.sc_id+'"]').addClass('playing');
    });*/

    if(track_actions) {
      mixpanel.track("previous track click", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
  });

  $('#player-volume-up').click(function() {
    if(loading) return false;

    player.mute();

    $(this).hide();
    $('#player-volume-off').show();

    if(track_actions) {
      mixpanel.track("unmute track", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
  });

  $('#player-volume-off').click(function() {
    if(loading) return false;

    player.unmute();

    $(this).hide();
    $('#player-volume-up').show();

    if(track_actions) {
      mixpanel.track("mute track", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
  });

  $('#player-shuffle').click(function() {
    if(loading) return false;

    //player.shuffle();

    if(track_actions) {
      mixpanel.track("shuffled playlist", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
  });

  $('#player-play').click(function() {
    if(loading) return false;

    player.play();

    $('#player-pause').show();
    $('#player-play').hide();

    if(track_actions) {
      mixpanel.track("play control click", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
  });

  $('#player-pause').click(function() {
    if(loading) return false;

    player.pause();

    $('#player-pause').hide();
    $('#player-play').show();

    if(track_actions) {
      mixpanel.track("pause control click", {
        "genre": genre,
        "track": track_list[track_index].id,
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
        "genre": genre,
        "track": track_list[track_index].id,
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
