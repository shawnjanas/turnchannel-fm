$(document).ready(function() {
  var tags_selected = [];
  $('.landing-background .tags a').click(function() {
    var tag = $(this).attr('tag');
    tags_selected.push(tag);

    if(tags_selected.length > 1) {
      window.location = '/mixes/tags/'+tags_selected[0]+'+'+tags_selected[1]
    }
    e.preventDefault();
  });

  $('#mix-fav-btn').click(function() {
    var btn = $(this);
    var href = $(this).attr('href');
    console.log('click');
    console.log(href);
    $.post(href, function(d) {
      if(d.state == 1) {  // Selected
        btn.addClass('btn-primary');
      } else {
        btn.removeClass('btn-primary');
      }
    }).error(function(e) {
      if(e.status == 401) {
        window.location = '/users/sign_up'
      } else {
        alert('An unexpected error has occured. Please try again...');
      }
    });
  });

  $('.playlist-container .playlist-track').hover(function() {
    $(this).find('.track-play').show();
  }, function() {
    $(this).find('.track-play').hide();
  });

  $('.playlist-container .playlist-track').click(function() {
    var playlist_index = $(this).attr('index'); 
    player.playVideoAt(playlist_index);

    //newTrackPlaying(playlist_index);
  });

  window.scrollBy(0,158);
});

function newTrackPlaying(playlist_index) {
  console.log(playlist_index);
  $('.playlist-container .playlist-track.playing').removeClass('playing');
  $('.playlist-container .playlist-track[index="'+playlist_index+'"]').addClass('playing');

  track_name = $('.playlist-container .playlist-track[index="'+playlist_index+'"] h4').html();
  $('.player-title h3').html('► '+track_name);
}

//Load player api asynchronously.
var tag = document.createElement('script');
tag.src = "//www.youtube.com/player_api";
var firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
var done = false;
var player;

function onYouTubePlayerAPIReady() {
  var playlist_ids = $('.playlist').attr('ids');

  player = new YT.Player('ytapiplayer', {
    height: '560',
    width: '960',
    videoId: playlist_ids.split(',')[0],
    playerVars: { 'playlist':playlist_ids.split(',').slice(1, playlist_ids.length).join(','), 'showinfo': 0, 'modestbranding': 1, 'autohide': 0, 'iv_load_policy': 3, 'autoplay': 1, 'rel': 0},
    events: {
    //  'onReady': onPlayerReady,
      'onStateChange': onPlayerStateChange
    }
    //http://www.youtube.com/v/8eqcPsA_9sk?version=3&enablejsapi=1&showinfo=0&modestbranding=1&autohide=1&iv_load_policy=3&autoplay=0&rel=0&playlist=wyx6JDQCslE,P7iESu2XuCU,RMsrAHAN3Js,LJdbMnFkXwU,ygQtml-Xsog,W4aoqY9Rcd8,YbVOEyUx8M0,bEz6pXw9ONY,1vvSmEY5TFI
  });
}

/*function onPlayerReady(evt) {
  evt.target.playVideo();
}*/
function onPlayerStateChange(evt) {
  var data = evt.data;
  var target = evt.target;

  console.log(evt);
  console.log(target.getVideoUrl());

  if(data == YT.PlayerState.PAUSED) {
    // Register MixPanel Event
  } else if(data == YT.PlayerState.PLAYING) {
    newTrackPlaying(target.getPlaylistIndex());
  } else if(data == -1) {
  }
  //if (evt.data == YT.PlayerState.PLAYING && !done) {
  //    setTimeout(stopVideo, 6000);
  //    done = true;
  //}

}
/*function stopVideo() {
  player.stopVideo();
}*/

