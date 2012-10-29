$(document).ready(function() {
  var track_actions = false;

  var player = new Player('e3216af75bcd70ee4e5d91a6b9f1d302');

  setInterval(function() {
    if(player.loading || !player.loaded) return false;

    var sound = player.getSound();

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
    if(player.loading) return false;

    player.nextTrack(function(err, track) {
      $('.playlist-tracks-content .playing').removeClass('playing');
      $('.playlist-tracks-content .track[track-id="'+track.sc_id+'"]').addClass('playing');
    });

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
    if(player.loading) return false;

    player.preTrack(function(err, track) {
      $('.playlist-tracks-content .playing').removeClass('playing');
      $('.playlist-tracks-content .track[track-id="'+track.sc_id+'"]').addClass('playing');
    });

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
    if(player.loading) return false;

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
    if(player.loading) return false;

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
    if(player.loading) return false;

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
    if(player.loading) return false;

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
    if(player.loading) return false;

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
    pause_player();
  });

  $('#player-seek').click(function(e) {
    if(player.loading) return false;

    var x = e.offsetX;
    var seek_width = $('#player-seek').width();
    var per_seek = (x/seek_width);

    var sound = player.getSound();
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

  $('.play-column').live('click', function() {
    if(player.loading) return false;

    var track_id = $(this).parent().attr('track-id');
    player.playTrack(track_id);

    //fetch_track($(this).parent().attr('track-id'));
  })

  $('#playall').live('click', function() {
    if(player.loading) return false;

    var track_id = $($('.playlist-tracks-content .track')[0]).attr('track-id');
    player.playTrack(track_id, function(track) {
      
    });
  });

  // Click events
  $('a').live('click', function(e) {
    var href = $(this).attr('href');
    var url = href+'?v='+Date.now();

    $.ajax({
      url: url,
      dataType: 'html',
      success: function(data) {
        $('.main-container').html(data);
        window.history.pushState(href, document.title, href);
      }
    });

    return false;
  });

  $('#player i').hover(function() {
    $(this).css('opacity', 0.8);
  }, function() {
    $(this).css('opacity', 1);
  });

  /*if(window.history.pushState) {
    var genre = window.location.hash.substring(1);

    if(typeof genre_hash[genre] !== 'undefined') {
      window.history.pushState(genre, document.title, "/"+genre);

      $('#topbar .active').removeClass('active');
      $('#'+genre).parent().addClass('active');
    } else {
      genre = window.location.pathname.substring(1);

      if(window.location.pathname == '/' || typeof genre_hash[genre] === 'undefined') {
        window.history.pushState('house', document.title, "/house");
      }
    }
  } else if(!window.history.pushState) {
    var genre = window.location.hash.substring(1);

    if(typeof genre_hash[genre] !== 'undefined') {
      $('#topbar .active').removeClass('active');
      $('#'+genre).parent().addClass('active');
    } else {
      window.location.hash = $('#topbar .active a').id();
    }
  }

  genre_index = genre_hash[$('#topbar .active a').attr('id')].index;
  */

  if(window.history.pushState) {
    window.onpopstate = function(e) {
      if(e.state == null) return false;

      var url = e.state;
      console.log(url);

      if(track_actions) {
        mixpanel.track("play genre", {
          "genre": genre
        });
      }

      $.ajax({
        url: url,
        dataType: 'html',
        success: function(data) {
          $('.main-container').html(data);
        }
      });
    };
  } else {
    $(window).bind("hashchange",function(e) {
      var genre = window.location.hash.substring(1);

      if($('#topbar .active a').attr('id') != genre) {
        if(track_actions) {
          mixpanel.track("play genre", {
            "genre": genre
          });
        }
        $('#topbar .active').removeClass('active');
        $('#'+genre).parent().addClass('active');

        genre_index = genre_hash[genre].index;
        show_tracks(genre);

        window.scrollTo(0, 0);
      }
    });
  }



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
