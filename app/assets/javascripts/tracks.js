$(document).ready(function() {
  var track_list = [];
  var track_index = 0;

  var sound;

  $.getJSON('/tracks/genre/dubstep', function(data) {
    console.log(data);
    track_list = data;

    init();
    play();
  });

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
    console.log(track_list.length);
    $('#queue').css('width', (track_list.length*101)+'px');
  }

  function play() {
    var track = track_list[track_index];
    var id = track.id;

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
      },
      onerror: function(e) {
        alert('Error: '+e);
      },
      onfinish: function() {
        track_index = (track_index+1) % track_list.length;
        play();
      }
    }, function(s) {
      sound = s;

      var minutes = sound.durationEstimate / 1000 / 60;
      var seconds = (sound.durationEstimate / 1000) - (minutes * 60);

      $('#player-duration').html();
    });
  }


  var bg_list = ['http://www.superbwallpapers.com/wallpapers/girls/abigail-clancy-3728-1920x1080.jpg', 'http://www.superbwallpapers.com/wallpapers/girls/petra-cubonova-13070-1920x1080.jpg', 'http://www.superbwallpapers.com/wallpapers/girls/adriana-lima-3933-1920x1200.jpg', 'http://www.superbwallpapers.com/wallpapers/music/headphones-14936-1920x1080.jpg', 'http://www.superbwallpapers.com/wallpapers/music/music-14219-1920x1080.jpg', 'http://www.superbwallpapers.com/wallpapers/music/headphones-14798-1920x1080.jpg', 'http://www.superbwallpapers.com/wallpapers/girls/abbey-lee-kershaw-13519-1440x900.jpg', 'http://www.superbwallpapers.com/wallpapers/girls/lorena-garcia-14046-1920x1080.jpg', 'http://www.superbwallpapers.com/wallpapers/celebrities/kimbra-lee-johnson-14235-1920x1080.jpg', 'http://good-wallpapers.com/wallpapers/16996/dubstep-wallpaper.jpg', 'http://1.bp.blogspot.com/-D_7XVbi42rs/TkKmfPhD-SI/AAAAAAAAAFU/6Ij9g2G3exs/s1600/lovely-girls-wallpaper.jpg', 'http://fc01.deviantart.net/fs71/f/2010/282/3/5/dubstep_wallpaper_by_rob_c-d2e50xs.jpg', 'http://2.bp.blogspot.com/-FEAVPqC_xz4/T4sbSYWgBuI/AAAAAAAACyc/VVp-q9Ox3N8/s1600/Hot_Girls_0005+B&W.jpg', 'http://fc06.deviantart.net/fs71/f/2011/219/d/7/dubstep_wallpaper_white_by_thegregeth-d45s4th.jpg', 'http://www.funonclick.com/fun/Uploaded/Hot%20Girls%20-%20121-20269.jpg', 'http://www.artswallpapers.com/GirlsWallpapers/images/Hot%20Girls%20Wallpaper%2005.jpg', 'http://www.superbwallpapers.com/wallpapers/girls/adriana-lima-3833-1920x1200.jpg'];
  var bg_index = 0;

  for(var i = 0; i < bg_list.length; i++) {
    var bg = bg_list[i];

    $('.landing-background').append('<img id="bg-'+i+'" style="display:none;" src="'+bg+'">');
  }
  $($('.landing-background img')[0]).show();

  // Sideshow
  function bg_next() {
    var bg_active = $('.landing-background #bg-'+bg_index);
    bg_index = (bg_index+1) % bg_list.length;

    $('.landing-background #bg-'+bg_index).show();
    bg_active.hide();
  }

  setInterval(function() {
    bg_next();
  }, 10000);

  setInterval(function() {
    if(typeof sound === 'object') {
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
    if(typeof sound !== 'object') {
      return false;
    }

    sound.play();

    $(this).hide();
    $('#player-pause').show();
  });

  $('#player-pause').click(function() {
    if(typeof sound !== 'object') {
      return false;
    }

    sound.pause();

    $(this).hide();
    $('#player-play').show();
  });

  $('#player-step-forward').click(function() {
    if(typeof sound !== 'object') {
      return false;
    }

    sound.pause();
    track_index = (track_index+1) % track_list.length;
    play();
  });

  $('#player-step-backward').click(function() {
    if(typeof sound !== 'object') {
      return false;
    }

    sound.pause();

    track_index--;
    if(track_index < 0) {
      track_index = track_list.length-1;
    }

    play();
  });

  $('#player-volume-up').click(function() {
    if(typeof sound !== 'object') {
      return false;
    }
    sound.mute();
    
    $(this).hide();
    $('#player-volume-off').show();
  });

  $('#player-volume-off').click(function() {
    if(typeof sound !== 'object') {
      return false;
    }
    sound.unmute();
    
    $(this).hide();
    $('#player-volume-up').show();
  });

  $('#player-minus').click(function() {
    $('#queue-wrapper').hide();
    $('footer').css('height', '69px');

    $(this).hide();
    $('#player-plus').show();
  });

  $('#player-plus').click(function() {
    $('#queue-wrapper').show();
    $('footer').css('height', '205px');

    $(this).hide();
    $('#player-minus').show();
  });

  $('.track').live({
    mouseenter: function() {
      $(this).find('.track-play').show();
    },
    mouseleave: function() {
      $(this).find('.track-play').hide();
    }
  });
  $('.track').live('click', function() {
    var track_id = $(this).attr('id').split('-')[1];

    for(var i = 0; i < track_list.length; i++) {
      var track = track_list[i];

      if(track.id == track_id) {
        if(track_index == i) {
          if(sound.paused) {
            $('#player-play').click();
          } else {
            $('#player-pause').click();
          }
        } else {
          sound.pause();

          track_index = i;
          play();
        }
        break;
      }
    }
  });
});
