$(document).ready(function() {
  var track_actions = true;

  var sound;

  var tracks = {};
  var track_list = [];
  var track_index = -1;

  var genre_index = 0;
  var genres = ['house', 'dubstep', 'dnb']

  var genre_hash = {
    'house': {
      index: 0,
      sc_id: 5614319
    },
    'dubstep': {
      index: 1,
      sc_id: 3158948
    },
    'dnb': {
      index: 2,
      sc_id: 12104873
    }
  };

  var loading = false;
  var loaded = false;


  SC.initialize({
    client_id: 'e3216af75bcd70ee4e5d91a6b9f1d302'
  });

  if(window.history.pushState) {
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
  }

  var load_genre_callbacks = genres.length;

  for(var i = 0; i < genres.length; i++) {
    load_genre(genres[i]);
  }

  function load_genre(genre) {
    SC.get("/users/"+genre_hash[genre].sc_id+"/tracks", {limit: 200}, function(data){
      var _tracks = [];
      for(var i in data) {
        if(data[i].streamable && data[i].duration < 600000) {
          _tracks.push(data[i]);
        }
      }
      tracks[genre] = _tracks;

      if(genre == genres[genre_index]) {
        show_tracks(genre);
      }
      if(--load_genre_callbacks == 0) {
        loaded = true;
      }
    });
  }

  function show_tracks(genre) {
    var _tracks = tracks[genre];

    $('#queue').html('');
    for(var i = 0; i < _tracks.length; i++) {
      var track = _tracks[i];
      var track_id = track.id;
      var track_art = track.artwork_url || 'http://images.grooveshark.com/static/albums/70_album.png';

      var _title = track.title.split(' by ');
      var title = _title[0];
      var artist = _title[1];

      var c = 'track';
      if(genres[genre_index] == genre && track_index != -1 && track_id == track_list[track_index].id) {
        c = 'track playing';
      }

      var track_html = '<div id="track-'+track_id+'" class="'+c+'"><div class="artwork"><div class="track-play"><i class="icon-play icon-white"></i></div><div class="track-pause"><i class="icon-pause icon-white"></i></div><img src="'+track_art+'" height="100px" width="100px" /></div><div class="title"><div class="artist">'+artist+'</div><div class="title">'+title+'</div></div></div>';

      $('#queue').append(track_html);
    }
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

  function play() {
    var track = track_list[track_index];
    var id = track.id;

    $('head title').html('► '+track.title+'|'+genres[genre_index]+'|'+'TurnChannel');

    SC.stream("/tracks/"+id, {
      autoPlay: true,
      ontimedcomments: function(comments) {
        var comment = comments[0].body;
        $('#track-comments').html(comment);
      },
      onplay: function(s) {
        var track_art = track.artwork_url || 'http://images.grooveshark.com/static/albums/70_album.png';

        var _title = track.title.split(' by ');
        var title = _title[0];
        var artist = _title[1];

        $('#track-artwork').html('<img src="'+track_art+'" />');
        $('#track-title').html('<a href="'+track.permalink_url+'" target="_blank"><span>'+title+'</span> by <span>'+artist+'</span></a> - ');

        $('.playing').removeClass('playing');
        $('#track-'+id).addClass('playing');

        loading = false;
      },
      onerror: function(e) {
        alert('Error: '+e);
      },
      onfinish: function() {
        if(track_actions) {
          mixpanel.track("track finished", {
            "genre": genre,
            "track": track_list[track_index].id
          });
        }

        track_index = (track_index+1) % track_list.length;
        play();
      }
    }, function(s) {
      sound = s;

      var minutes = sound.durationEstimate / 1000 / 60;
      var seconds = (sound.durationEstimate / 1000) - (minutes * 60);

      $('#player-duration').html();

      $('#player-pause').show();
      $('#player-play').hide();
    });
  }

  function stop() {
    if(typeof sound === 'object') {
      sound.stop();
    }
  }

  var bg_index = 0;
  var bg_length = $('.landing-background img').length;

  setTimeout(function() {
    for(var i = 1; i < bg_length; i++) {
      $('.landing-background #bg-'+i).hide();
    }
  }, 1000);

  setInterval(function() {
    if(typeof sound === 'object' && !loading) {
      // Elapsed time
      var position = sound.position;
      var duration_est = sound.durationEstimate;

      var loaded_ratio = position / duration_est;
      var seek_width = Math.floor(loaded_ratio * 685);

      $('#player-elapsed').html(to_time(position));
      $('#player-duration').html(to_time(duration_est));
      $('#player-progress-bar-meter').css('width', seek_width+'px');
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
    shuffle(track_list);
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

  $('#player-seek').click(function() {
    if(typeof sound !== 'object' || loading) {
      return false;
    }

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
    track_index = (track_index+1) % track_list.length;
    play();
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

    track_index--;
    if(track_index < 0) {
      track_index = track_list.length-1;
    }

    play();
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

  $('.track').live({
    mouseenter: function() {
      if($(this).hasClass('playing') && (typeof sound !== 'object' || (typeof sound === 'object' && !sound.paused))) {
        $(this).find('.track-pause').show();
      } else {
        $(this).find('.track-play').show();
      }
    },
    mouseleave: function() {
      $(this).find('.track-pause').hide();
      $(this).find('.track-play').hide();
    }
  });
  $('.track').live('click', function() {
    if(loading) return false;

    var _tracks = tracks[genres[genre_index]];
    var track_id = $(this).attr('id').split('-')[1];
    for(var i = 0; i < _tracks.length; i++) {
      var track = _tracks[i];

      if(track.id == track_id) {
        if(track_index == i) {
          if(sound.paused) {
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
    }
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
