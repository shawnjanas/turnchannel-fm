var player;

$(document).ready(function() {
  var track_id = $('.track-containerr').attr('track-id');
  if(track_id === undefined) {
    return;
  }
  loadPlayer(track_id, function(p) {
    player = p;
    init();
  });
});

function loadPlayer(track_id, callback) {
  SC.initialize({
    client_id: 'e3216af75bcd70ee4e5d91a6b9f1d302'
  });
  SC.get("/tracks/"+track_id, function(track, error) {
    if(error && error.message == '404 - Not Found') {
      alert("Track not found!");
    } else {
      SC.stream("/tracks/"+track_id, {
        autoPlay: true,
        useHTML5Audio: true,
        ontimedcomments: this._ontimedcomments,
        onplay: this._onplay,
        onerror: this._onerror,
        onfinish: function() {
          var href = $('.next-track').attr('href');
          window.location = href;
        }
      }, callback);
    }
  });
}

function init() {

  $('.track-containerr img').click(function() {
    player.paused ? player.play() : player.pause();
  });

  // Handle progress bar click
  $('.progress-bar').click(function(e) {
    var x = e.offsetX;
    var width = $(this).width();
    var pos = x/width;

    console.log(pos * player.durationEstimate);
    console.log(player.durationEstimate);
    console.log(player);

    player.setPosition(pos * player.durationEstimate);
  });

  // Update seek bar
  setInterval(function() {
    // Elapsed time
    var position = player.position;
    var duration_est = player.durationEstimate;

    var loaded_ratio = position / duration_est;
    var seek_width = loaded_ratio * 100;

    $('.seek').css('width', seek_width+'%');
  }, 500);

  mixpanel.track_links('.uploaded-by-turnchannel a', 'Track Upload Track Click');
}




$(document).ready(function() {
  var track_actions = true;

  $('.track').hover(function() {
    $(this).find('.track-item-title').addClass('hover');
    if($(this).find('.track-play.selected').length == 0) {
      $(this).find('.track-play').show();
    }
  }, function() {
    $(this).find('.track-item-title').removeClass('hover');
    if($(this).find('.track-play.selected').length == 0) {
      $(this).find('.track-play').hide();
    }
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
  var auto_play = $('.player').attr('auto-play') == 'true' || false;

  if(auto_play) {
    $('#player-pause').css('display', 'inline-block');
    $('#player-play').hide();
  } else {
    $('#player-play').css('display', 'inline-block');
    $('#player-pause').hide();
  }

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
        autoPlay: auto_play,
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
            "genre": $('.player-genre-bar').find('h4').html()
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

  $('#save-track').click(function(e) {
    var btn = $(this);
    var href = $(this).attr('href');

    e.preventDefault();

    $.post(href, function(d) {
      if(d.state == 1) {  // Selected
        btn.html('<i class="icon-star icon-white"/> Unsave');

        if(track_actions) {
          mixpanel.track("save track click");
        }
      } else {
        btn.html('<i class="icon-star-empty icon-white"/> Saved');

        if(track_actions) {
          mixpanel.track("unsave track click");
        }
      }

    }).error(function(e) {
      if(e.status == 401) {
        //$('.register-btn').click();
        $('#sign-in-modal').modal('show');
      } else {
        alert('An unexpected error has occured. Please try again...');
      }
    });
  });

  $('.scroll-pane').jScrollPane();

  if(track_actions) {
    mixpanel.track_links('.featured-tracks-container .featured-track-item a', 'featured track click');
    mixpanel.track_links('.featured-tracks-container .featured-track-main a', 'featured track main click');
    mixpanel.track_links('.discover-track-item a', 'discover genre click');
    mixpanel.track_links('.topbar-link', 'discover click');
    mixpanel.track_links('.new-track-item a', 'new track click');
    mixpanel.track_links('.right-bar .top10-track-item a', 'top10 track click');
    mixpanel.track_links('.related-track-item a', 'related track click');
    mixpanel.track_links('.search-track-item a', 'search track click');
    mixpanel.track_links('.register-btn', 'register button click');
    mixpanel.track_links('#player-step-forward a', 'next track click');
    mixpanel.track_links('.player-queue a', 'player queue track click');
    mixpanel.track_links('#discover-guide a', 'genre guide bar click');
    mixpanel.track_links('#favorites-guide a', 'saved tracks guide bar click');
    //mixpanel.track_links('#upvote', 'upvote btn click');
    //mixpanel.track_links('#downvote', 'downvote btn click');
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
