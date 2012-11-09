var player;

$(document).ready(function() {
  //Load player api asynchronously.
  var tag = document.createElement('script');
  tag.src = "//www.youtube.com/player_api";
  var firstScriptTag = document.getElementsByTagName('script')[0];
  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

  var tags_selected = [];

  $('.landing-background .tags a').click(function() {
    var tag = $(this).attr('tag');
    tags_selected.push(tag);

    if(tags_selected.length > 1) {
      window.location = '/mixes/tags/'+tags_selected[0]+'+'+tags_selected[1]
    }
    e.preventDefault();
  });

  $('#global-search').submit(function(e) {
    window.location = '/mixes/search/'+$(this).find('#global-search-field').val();
    return false;
  });

  $('#mix-fav-btn').click(function() {
    var btn = $(this);
    var href = $(this).attr('href');

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

  $('#mix-tracks-btn').click(function() {
    window.scrollBy(0,0);
  });

  $('.playlist-container .playlist-track').hover(function() {
    if(!$(this).hasClass('playing')) {
      $(this).find('.track-play').show();
    }
  }, function() {
    if(!$(this).hasClass('playing')) {
      $(this).find('.track-play').hide();
    }
  });

  $('.playlist-container .playlist-track').click(function() {
    var playlist_index = $(this).attr('index'); 
    player.playVideoAt(playlist_index);
  });

  window.scrollBy(0,183);
});

function newTrackPlaying(playlist_index) {
  console.log(playlist_index);
  $('.playlist-container .playlist-track.playing .track-play').hide();
  $('.playlist-container .playlist-track.playing').removeClass('playing');
  $('.playlist-container .playlist-track[index="'+playlist_index+'"]').addClass('playing');
  $('.playlist-container .playlist-track[index="'+playlist_index+'"] .track-play').show();

  track_artist = $('.playlist-container .playlist-track[index="'+playlist_index+'"] .track-artist').html();
  track_name = $('.playlist-container .playlist-track[index="'+playlist_index+'"] .track-name').html();

  $('.player-title .player-artist').html(track_artist);
  $('.player-title .player-name').html(track_name);
}

function onYouTubePlayerAPIReady() {
  var playlist_ids = $('.playlist').attr('ids');

  player = new YT.Player('ytapiplayer', {
    height: '560',
    width: '960',
    videoId: playlist_ids.split(',')[0],
    playerVars: { 'playlist':playlist_ids.split(',').slice(1, playlist_ids.length).join(','), 'showinfo': 0, 'modestbranding': 1, 'autohide': 0, 'iv_load_policy': 3, 'autoplay': 1, 'rel': 0},
    events: {
      'onStateChange': onPlayerStateChange
    }
  });
}

function onPlayerStateChange(evt) {
  var data = evt.data;
  var target = evt.target;

  if(data == YT.PlayerState.PAUSED) {
    // Register MixPanel Event
  } else if(data == YT.PlayerState.PLAYING) {
    newTrackPlaying(target.getPlaylistIndex());
  } else if(data == -1) {
  }
}
