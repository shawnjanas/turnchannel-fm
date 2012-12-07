var player;
var loaded;
var track_actions = false;

$(document).ready(function() {

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

  if($('#ytapiplayer').length > 0) {
    //Load player api asynchronously.
    var tag = document.createElement('script');
    tag.src = "//www.youtube.com/player_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
  }

  /*
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

    loading = false;
    loaded = true;
    if(track_actions) {
      mixpanel.track("play track", {
        "duration": $('#player-duration').html()
      });
    }
  });
  */

  setInterval(function() {
    if(!loaded) return false;

    var sound = player;

    // Elapsed time
    var position = sound.getCurrentTime();
    var duration_est = sound.getDuration();

    var loaded_ratio = position / duration_est;
    var seek_width = loaded_ratio * 100;

    $('#player-elapsed').html(to_time(position));
    $('#player-duration').html(to_time(duration_est));
    $('#player-progress-bar-meter').css('width', seek_width+'%');
  }, 500);

  /*

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
  */

  $('#player-seek').click(function(e) {
    if(!loaded) return false;

    var x = e.offsetX;
    var seek_width = $('#player-seek').width();
    var per_seek = (x/seek_width);

    var sound = player;
    sound.seekTo(Math.floor(per_seek * sound.getDuration()), true);

    if(track_actions) {
      mixpanel.track("seek bar click", {
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
  });

  /*

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
  }
  */

  function to_time(time) {
    var total_seconds = Math.floor(time);

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
function onYouTubePlayerAPIReady() {
  player = new YT.Player('ytapiplayer', {
    width: '560',
    height: '315',
    videoId: '9DDs_tInLB0',
    playerVars: { 'showinfo': 0, 'modestbranding': 1, 'autohide': 0, 'iv_load_policy': 3, 'autoplay': 1, 'rel': 0, 'theme': 'light', 'wmode': 'transparent'},
    events: {
      'onStateChange': onPlayerStateChange
    }
  });
  loaded = true;
}
function onPlayerStateChange(evt) {
  /*
  var data = evt.data;
  var target = evt.target;

  if(data == YT.PlayerState.PAUSED) {
    mixpanel.track("track paused", {
      "track": $('.playlist-container .playlist-track.playing .track-artist').html() + " - " + $('.playlist-container .playlist-track.playing .track-name').html()
    });
  } else if(data == YT.PlayerState.ENDED) {
    if(track_actions) {
      mixpanel.track("track finished", {
        "track": $('.playlist-container .playlist-track.playing .track-artist').html() + " - " + $('.playlist-container .playlist-track.playing .track-name').html()
      });
    }
  } else if(data == YT.PlayerState.PLAYING) {
    mixpanel.track("track play", {
      "track": $('.playlist-container .playlist-track.playing .track-artist').html() + " - " + $('.playlist-container .playlist-track.playing .track-name').html()
    });
    newTrackPlaying(target.getPlaylistIndex());
  } else if(data == -1) {
  }
  */
}
