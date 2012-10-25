$(document).ready(function() {
  var track_actions = false;

  var sound;

  var loading = false;
  var loaded = false;

  SC.initialize({
    client_id: 'e3216af75bcd70ee4e5d91a6b9f1d302'
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

  if(window.history.pushState) {
    window.onpopstate = function(e) {
      if(e.state == null) return false;

      var genre = e.state;

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
  }*/

  function load_track(track) {
    var id = track.id;

    var track_art = track.artwork_url.replace('large', 't300x300') || 'http://images.grooveshark.com/static/albums/300_album.png';

    var title = track.title;
    var artist = track.artist;

    $('#player-title').html(title)
    $('#player-artist').html(artist)
    $('#player-artwork img').attr('src', track_art)

    /*$('#track-artwork').html('<img src="'+track_art+'" />');
    $('#track-title').html('<a href="'+track.permalink_url+'" target="_blank"><span>'+title+'</span> by <span>'+artist+'</span></a> - ');

    $('.playing').removeClass('playing');
    $('#track-'+id).addClass('playing');*/
  }

  $('.genre-link').click(function(e) {
    var genre = $(this).attr('id');

    if(track_actions) {
      mixpanel.track("play genre", {
        "genre": genre
      });
    }

    $(this).parent().parent().find('.active').removeClass('active');
    $(this).parent().addClass('active');

    genre_index = genre_hash[genre].index;
    show_tracks(genre);

    if(window.history.pushState) {
      window.history.pushState(genre, document.title, "/"+genre);
    } else {
      window.location.hash = genre;
    }
    window.scrollTo(0, 0);

    e.preventDefault();
  });

  $('#player i').hover(function() {
    $(this).css('opacity', 0.8);
  }, function() {
    $(this).css('opacity', 1);
  });

  function play(track) {
    var id = track.sc_id;

    /*if(autoPlay) {
      $('head title').html('► '+track.title+'|'+genres[genre_index]+'|'+'TurnChannel');
    } else {
      $('head title').html(track.title+'|'+genres[genre_index]+'|'+'TurnChannel');
    }*/

    SC.stream("/tracks/"+id, {
      autoPlay: true,
      useHTML5Audio: true,
      ontimedcomments: function(comments) {
        //var comment = comments[0].body;
        //$('#track-comments').html(comment);
      },
      onplay: function(s) {
        $('#player-pause').show();
        $('#player-play').hide();

        loading = false;
      },
      onerror: function(e) {
        alert('Error: '+e);
      },
      onfinish: function() {
        /*if(track_actions) {
          mixpanel.track("track finished", {
            "genre": genre,
            "track": track_list[track_index].id
          });
        }*/

        $('.playlist-tracks-content .playing').next().find('.play-column').click();
      }
    }, function(s) {
      sound = s;
      load_track(track);
    });
  }

  function stop() {
    if(typeof sound === 'object') {
      sound.stop();
    }
  }

  setInterval(function() {
    if(typeof sound === 'object' && !loading) {
      // Elapsed time
      var position = sound.position;
      var duration_est = sound.durationEstimate;

      var loaded_ratio = position / duration_est;
      var seek_width = loaded_ratio * 100;

      $('#player-elapsed').html(to_time(position));
      $('#player-duration').html(to_time(duration_est));
      $('#player-progress-bar-meter').css('width', seek_width+'%');
    }
  }, 500);

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

  $('#player-shuffle').click(function() {
    if(typeof sound !== 'object' || loading) {
      return false;
    }

    if(track_actions) {
      mixpanel.track("shuffled playlist", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }

    sound.pause();
    $('.playlist-tracks-content .playing').removeClass('.playing');

    track_list = $('.playlist-tracks-content .track').removeClass('odd');
    shuffle(track_list);

    for(var i = 0; i < track_list.length; i++) {
      if(i % 2 == 1) {
        $(track_list[i]).addClass('odd');
      }
    }

    $('.playlist-tracks-content tbody').html(track_list);
    $(track_list[0]).find('.play-column').click();
  });
  $('#player-play').click(function() {
    if(typeof sound !== 'object' || loading) {
      return false;
    }

    if(track_actions) {
      mixpanel.track("play control click", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
    play_player();
  });

  $('#player-pause').click(function() {
    if(typeof sound !== 'object' || loading) {
      return false;
    }

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

  function play_player() {
    sound.play();

    $('#player-play').hide();
    $('#player-pause').show();

    var title = $('title').html();
    $('title').html('► '+title);
  }

  function pause_player() {
    sound.pause();

    $('#player-pause').hide();
    $('#player-play').show();

    var title = $('title').html();
    $('title').html(title.substring(2));
  }

  $('#track-title').click(function() {
    if(typeof sound !== 'object' || loading) {
      return false;
    }

    if(track_actions) {
      mixpanel.track("track sc link click", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
  });

  $('#player-seek').click(function(e) {
    if(typeof sound !== 'object' || loading) {
      return false;
    }

    var x = e.offsetX;
    var seek_width = $('#player-seek').width();
    var per_seek = (x/seek_width);

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

  $('#player-step-forward').click(function() {
    if(typeof sound !== 'object' || loading) {
      return false;
    }

    if(track_actions) {
      mixpanel.track("next track click", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }

    sound.pause();
    $('.playlist-tracks-content .playing').next().find('.play-column').click();
  });

  $('#player-step-backward').click(function() {
    if(typeof sound !== 'object' || loading) {
      return false;
    }

    if(track_actions) {
      mixpanel.track("previous track click", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }

    sound.pause();

    $('.playlist-tracks-content .playing').prev().find('.play-column').click();
  });

  $('#player-volume-up').click(function() {
    if(typeof sound !== 'object' || loading) {
      return false;
    }
    if(track_actions) {
      mixpanel.track("unmute track", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
    sound.mute();

    $(this).hide();
    $('#player-volume-off').show();
  });

  $('#player-volume-off').click(function() {
    if(typeof sound !== 'object' || loading) {
      return false;
    }
    if(track_actions) {
      mixpanel.track("mute track", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
    sound.unmute();

    $(this).hide();
    $('#player-volume-up').show();
  });

  $('.play-column').live('click', function() {
    if(loading) return false;

    stop();

    var track_id = $(this).parent().attr('track-id');
    $.getJSON('/tracks/'+track_id+'.json', function(data) {
      play(data);
    });

    $(this).parent().parent().find('.playing .play-column i').removeClass('icon-pause').addClass('icon-play');
    $(this).parent().parent().find('.playing').removeClass('playing');

    $(this).parent().addClass('playing');
    $(this).find('i').removeClass('icon-play').addClass('icon-pause');

    /*for(var i = 0; i < _tracks.length; i++) {
      var track = _tracks[i];

      if(track.id == track_id) {
        if(track_index == i) {
          if(sound.paused || sound.playState == 0) {
            play_player();

            $(this).find('.track-pause').show();
            $(this).find('.track-play').hide();
          } else {
            pause_player();

            $(this).find('.track-pause').hide();
            $(this).find('.track-play').show();
          }
        } else {
          if(typeof sound === 'object') {
            sound.pause();
          }

          track_list = _tracks;
          track_index = i;
          play();

          $(this).find('.track-pause').show();
          $(this).find('.track-play').hide();

          if(track_actions) {
            if(typeof sound !== 'object') {
              mixpanel.track("play custom track", {
                "genre": genre,
                "new_track": track_list[i].id,
                "track": -1,
                "elapsed": -1,
                "duration": -1
              });
            } else {
              mixpanel.track("play custom track", {
                "genre": genre,
                "new_track": track_list[i].id,
                "track": track_list[track_index].id,
                "elapsed": $('#player-elapsed').html(),
                "duration": $('#player-duration').html()
              });
            }
          }
        }
        break;
      }
    }*/
  });


  $('#submit-tracks-link').click(function(e) {
    if(track_actions) {
      mixpanel.track("submit tracks link clicked");
    }

    $('#main-wrapper').find('.selected').hide();
    $('#main-wrapper').find('.selected').removeClass('selected');

    $('#submit-tracks').addClass('selected');
    $('#submit-tracks').fadeToggle();
    e.preventDefault();
  });
  $('#contact-link').click(function(e) {
    if(track_actions) {
      mixpanel.track("contact link clicked");
    }

    $('#main-wrapper').find('.selected').hide();
    $('#main-wrapper').find('.selected').removeClass('selected');

    $('#contact').addClass('selected');
    $('#contact').fadeToggle();
    e.preventDefault();
  });

  $('.page .close').click(function(e) {
    $('#main-wrapper').find('.selected').fadeOut();
    $('#main-wrapper').find('.selected').removeClass('selected');
    e.preventDefault();
  });

  //shuffles list in-place
  function shuffle(list) {
    var i, j, t;
    for (i = 1; i < list.length; i++) {
      j = Math.floor(Math.random()*(1+i));  // choose j in [0..i]
      if (j != i) {
        t = list[i];                        // swap list[i] and list[j]
        list[i] = list[j];
        list[j] = t;
      }
    }
  }
});
