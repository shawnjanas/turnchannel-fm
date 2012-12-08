$(document).ready(function() {
  var track_actions = true;

  $('.track').hover(function() {
    $(this).find('.track-item-title').addClass('hover');
    $(this).find('.track-play').show();
  }, function() {
    $(this).find('.track-item-title').removeClass('hover');
    $(this).find('.track-play').hide();
  });

  $('#global-search').submit(function(e) {
    if(track_actions) {
      mixpanel.track("search query", {
        "query": $(this).find('#global-search-field').val()
      }, function() {
        var query = $('#global-search-field').val();
        window.location = '/tracks/search/'+$('#global-search-field').val();
      });
    } else {
      window.location = '/tracks/search/'+$('#global-search-field').val();
    }
    return false;
  });

  var interval;
  var featured_index = 0;
  $("#featured-track-"+featured_index).addClass('selected');

  function startInt() {
    return setInterval(function() {
      var track = $("#featured-track-"+featured_index)
      track.removeClass('selected');

      featured_index = ++featured_index % 8;

      track = $("#featured-track-"+featured_index)
      track.addClass('selected');

      var img_url = track.find('img').attr('src');
      var img_href = track.find('a').attr('href');

      $('.featured-track-main img').attr('src', img_url);
      $('.featured-track-main a').attr('href', img_href);
    }, 5000);
  }
  interval = startInt();

  $('.featured-tracks-container .featured-track-item').hover(function() {
    var img_url = $(this).find('img').attr('src');
    var img_href = $(this).find('a').attr('href');

    var id = $(this).attr('id').split('-')[2];
    featured_index = id;

    $(this).parent().parent().find('.selected').removeClass('selected');
    $(this).addClass('selected');
    $(this).parent().parent().find('.featured-track-main img').attr('src', img_url);
    $(this).parent().parent().find('.featured-track-main a').attr('href', img_href);
    clearInterval(interval);

    if(track_actions) {
      mixpanel.track("hover featured track", {
      });
    }
  }, function() {
    interval = startInt();
  });

  $('#global-search span').click(function() {
    $('#global-search').submit();
  });

  $('.register-btn').click(function() {
    $('.sign-in a').last().click();
  });

  var track_id = $('.player').attr('track-id');
  if(typeof track_id === 'undefined') return false;

  var player = undefined;
  var loading = true;
  var loaded = false;

  SC.initialize({
    client_id: 'e3216af75bcd70ee4e5d91a6b9f1d302'
  });
  SC.get("/tracks/"+track_id, function(track, error) {
    if(error && error.message == '404 - Not Found') {
      var href = $('.player').attr('next-track');
      window.location = href;
    } else {
      SC.stream("/tracks/"+track_id, {
        autoPlay: true,
        useHTML5Audio: true,
        ontimedcomments: this._ontimedcomments,
        onplay: this._onplay,
        onerror: this._onerror,
        onfinish: function() {
          var href = $('.player').attr('next-track');

          if(track_actions) {
            mixpanel.track("track finished", {
              "elapsed": $('#player-elapsed').html(),
              "duration": $('#player-duration').html()
            }, function() {
              window.location = href;
            });
          } else {
            window.location = href;
          }
        }
      }, function(s) {
        player = s;
        player.setVolume(50);

        loading = false;
        loaded = true;
        if(track_actions) {
          mixpanel.track("play track", {
            "duration": $('#player-duration').html()
          });
        }
      });
    }
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

  if(track_actions) {
    mixpanel.track_links('.featured-tracks-container .featured-track-item a', 'featured track click');
    mixpanel.track_links('.featured-tracks-container .featured-track-main a', 'featured track main click');
    mixpanel.track_links('.discover-track-item a', 'discover genre click');
    mixpanel.track_links('.topbar-link', 'discover click');
    mixpanel.track_links('.new-track-item a', 'new track click');
    mixpanel.track_links('.top10-track-item a', 'top10 track click');
    mixpanel.track_links('.related-track-item a', 'related track click');
    mixpanel.track_links('.search-track-item a', 'search track click');
    mixpanel.track_links('.register-btn', 'register button click');
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
