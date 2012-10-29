var Player = function(client_id) {
  this.sound = undefined;

  this.queue = [];
  this.queue_index = 0;

  this.loading = false;
  this.loaded = false;

  // Events
  this._ontimedcomments_callback = function() {};
  this._onplay_callback = function() {};
  this._onerror_callback = function() {};
  this._onfinish_callback = function() {};

  this.client_id = client_id;

  SC.initialize({
    client_id: client_id
  });
}

Player.prototype.playTrack = function(track, callback) {
  if(this.loading) return callback(new Error(''));

  var that = this;

  SC.stream("/tracks/"+track.sc_id, {
    autoPlay: true,
    useHTML5Audio: true,
    ontimedcomments: this._ontimedcomments,
    onplay: this._onplay,
    onerror: this._onerror,
    onfinish: this._onfinish
  }, function(s) {
    that._destroy_sound();
    that.sound = s;

    that.loading = false;
    that.loaded = true;

    callback(null, track);
  });
}

Player.prototype.play = function() {
  this.sound.play();
}

Player.prototype.stop = function() {
  this.sound.stop();
}

Player.prototype.pause = function() {
  this.sound.pause();
}

Player.prototype.nextTrack = function(callback) {
  this._destroy_sound();

  this.queue_index = (this.queue_index+1) % this.queue.length;

  var track = this.getTrack(this.queue_index);
  this.playTrack(track, function(){});

  callback(null, track);
}
Player.prototype.preTrack = function(callback) {
  this._destroy_sound();

  this.queue_index--;
  if(this.queue_index == -1) {
    this.queue_index = this.queue.length-1;
  }

  var track = this.getTrack(this.queue_index);
  this.playTrack(track, function(){});

  callback(null, track);
}

Player.prototype.getSound = function() {
  return this.sound;
}

Player.prototype.currentTrack = function() {
  return this.queue[this.queue_index];
}

Player.prototype.getTrack = function(index) {
  return this.queue[index];
}

Player.prototype.setQueue = function(tracks) {
  this._destroy_sound();

  this.queue = tracks;
  this.queue_index = 0;
}

Player.prototype._destroy_sound = function() {
  if(typeof this.sound === 'object') {
    this.sound.stop();
  }
  this.sound = undefined;
}

// Events
Player.prototype._onfinish = function() {
  this._destroy_sound();

  this.nextTrack(this._onfinish_callback);
}
Player.prototype._ontimedcomments = function() {
  this._ontimedcomments_callback();
}
Player.prototype._onplay = function() {
  //this._onplay_callback();
}
Player.prototype._onstop = function() {
  this._onstop_callback();
}
Player.prototype._onerror = function() {
  this._onerror_callback();
}

// Helper Functions
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
