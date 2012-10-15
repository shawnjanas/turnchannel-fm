$(document).ready(function() {
  var track_actions = true;

  var track_list = [];
  var track_index = 0;

  var sound;
  var genre = 'house';

  var loading = false;

  $('#submit-tracks-link').click(function() {
    if(track_actions) {
      mixpanel.track("submit tracks link clicked");
    }

    $('#main-wrapper').find('.selected').hide();
    $('#main-wrapper').find('.selected').removeClass('selected');

    $('#submit-tracks').addClass('selected');
    $('#submit-tracks').fadeToggle();
    e.preventDefault();
  });
  $('#submit-art-link').click(function() {
    if(track_actions) {
      mixpanel.track("submit art link clicked");
    }

    $('#main-wrapper').find('.selected').hide();
    $('#main-wrapper').find('.selected').removeClass('selected');

    $('#submit-art').addClass('selected');
    $('#submit-art').fadeToggle();
    e.preventDefault();
  });
  $('#contact-link').click(function() {
    if(track_actions) {
      mixpanel.track("contact link clicked");
    }

    $('#main-wrapper').find('.selected').hide();
    $('#main-wrapper').find('.selected').removeClass('selected');

    $('#contact').addClass('selected');
    $('#contact').fadeToggle();
    e.preventDefault();
  });

  $('.page .close').click(function() {
    $('#main-wrapper').find('.selected').fadeOut();
    $('#main-wrapper').find('.selected').removeClass('selected');
    e.preventDefault();
  });


  $('.genre-link').click(function() {
    if(loading) return false;

    var genre_id = $(this).attr('id');

    if(track_actions) {
      mixpanel.track("play genre", {
        "genre": genre_id
      });
    }

    $(this).parent().parent().find('.active').removeClass('active');
    $(this).parent().addClass('active');

    if(genre != genre_id) {
      genre = genre_id;
      track_index = 0;

      load_playlist();
    }
  });

  $('#player-shuffle').click(function() {
    if(loading) return false;

    if(track_actions) {
      mixpanel.track("shuffled playlist", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }
    load_playlist();
  });

  function load_playlist() {
    loading = true;
    reset_player();

    $.getJSON('/tracks/genre/'+genre, function(data) {
      track_list = data;

      init();
      play();
    });
  }

  function init() {
    SC.initialize({
      client_id: 'e3216af75bcd70ee4e5d91a6b9f1d302'
    });

    for(var i = 0; i < track_list.length; i++) {
      var track = track_list[i];
      var track_id = track.id;
      var track_art = track.artwork_url || 'http://images.grooveshark.com/static/albums/70_album.png';

      var track_html = '<div id="track-'+track_id+'" class="track"><div class="artwork"><div class="track-play"><i class="icon-play icon-white"></i></div><img src="'+track_art+'" height="90px" width="90px" /></div><div class="title">'+track.title+'</div></div>'

      $('#queue').append(track_html);
    }
    $('#queue').css('width', (track_list.length*101)+'px');
  }

  function play() {
    var track = track_list[track_index];
    var id = track.id;

    $('head title').html('► '+track.title+'|'+genre+'|'+'TurnChannel');

    SC.stream("/tracks/"+id, {
      autoPlay: true,
      ontimedcomments: function(comments) {
        var comment = comments[0].body;
        $('#track-comments').html(comment);
      },
      onplay: function(s) {
        $('#track-title').html('<a href="'+track.permalink_url+'" target="_blank">'+track.title + '</a> - ');

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

  function reset_player() {
    stop();

    $('#track-title').html('Loading...');
    $('#track-comments').html('');

    $('#player-pause').hide();
    $('#player-play').show();

    $('#player-elapsed').html('00:00');
    $('#player-duration').html('00:00');

    $('#player-progress-bar-meter').css('width','0');

    $('#queue').html('');
  }

  load_playlist();



  var bg_index = 0;
  var bg_length = $('.landing-background img').length;

  setTimeout(function() {
    for(var i = 1; i < bg_length; i++) {
      $('.landing-background #bg-'+i).hide();
    }
  }, 1000);

  // Sideshow
  function bg_next() {
    var bg_active = $('.landing-background #bg-'+bg_index);
    bg_index = (bg_index+1) % bg_length;

    $('.landing-background #bg-'+bg_index).show();
    bg_active.hide();
  }

  setInterval(function() {
    bg_next();
  }, 10000);

  setInterval(function() {
    if(typeof sound === 'object' || !loading) {
      // Elapsed time
      var position = sound.position;
      var duration_est = sound.durationEstimate;

      var loaded_ratio = position / duration_est;
      var seek_width = Math.floor(loaded_ratio * 800);

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
  }

  function pause_player() {
    sound.pause();

    $('#player-pause').hide();
    $('#player-play').show();
  }

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

  $('#player-minus').click(function() {
    if(track_actions) {
      mixpanel.track("hide playlist queue", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }

    $('#queue-wrapper').hide();
    $('footer').css('height', '69px');

    $(this).hide();
    $('#player-plus').show();
  });

  $('#player-plus').click(function() {
    if(track_actions) {
      mixpanel.track("show playlist queue", {
        "genre": genre,
        "track": track_list[track_index].id,
        "elapsed": $('#player-elapsed').html(),
        "duration": $('#player-duration').html()
      });
    }

    $('#queue-wrapper').show();
    $('footer').css('height', '205px');

    $(this).hide();
    $('#player-minus').show();
  });

  $('.track').live('click', function() {
    if(loading) return false;

    var track_id = $(this).attr('id').split('-')[1];
    for(var i = 0; i < track_list.length; i++) {
      var track = track_list[i];

      if(track.id == track_id) {
        if(track_index == i) {
          if(sound.paused) {
            play_player();
          } else {
            pause_player();
          }
        } else {
          if(track_actions) {
            mixpanel.track("play custom track", {
              "genre": genre,
              "new_track": track_list[i].id,
              "track": track_list[track_index].id,
              "elapsed": $('#player-elapsed').html(),
              "duration": $('#player-duration').html()
            });
          }

          sound.pause();
          track_index = i;
          play();
        }
        break;
      }
    }
  });
});
