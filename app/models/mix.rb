# Changes:
#   just-let-the-music-take-you => Kid Cuddie wrong track

class Mix < ActiveRecord::Base
  attr_accessible :name, :source, :remote, :description, :plays_count, :plays_history, :plays_weekly_count, :likes_count, :permalink, :cover_urls, :published, :first_published_at, :user_id, :duration, :searchable_metadata

  validates :remote, :presence => true, :uniqueness => true
  validates_presence_of :name, :source, :permalink, :user_id

  has_permalink :name

  belongs_to :user

  has_many :mix_tag_assignments
  has_many :tags, :through => :mix_tag_assignments

  has_many :track_mix_assignments
  has_many :tracks, :through => :track_mix_assignments

  has_many :favorite_mixes
  has_many :users_favorite, :through => :favorite_mixes

  def toggle_fav(user)
    if (favorite_mix = FavoriteMix.find_by_user_id_and_mix_id(user.id, self.id))
      favorite_mix.destroy
      0
    else
      FavoriteMix.create(:user_id => user.id, :mix_id => self.id)
      1
    end
  end

  def duration_time
    hours = (self.duration / 60 / 60).floor
    minutes = ((self.duration - (hours * 60 * 60)) / 60).floor
    seconds = self.duration - (hours * 60 * 60) - (minutes * 60)

    seconds = "0#{seconds}" if seconds < 10
    minutes = "0#{minutes}" if minutes < 10 && hours > 0

    unless hours == 0
      "#{hours}:#{minutes}:#{seconds}"
    else
      "#{minutes}:#{seconds}"
    end
  end

  def thumbnail
    tracks = self.tracks.where("remote IS NOT NULL").limit(4)
    if tracks.size == 4
      tracks.map do |track|
        track.thumbnail
      end
    elsif tracks.size > 0
      tracks.first.thumbnail
    else
      'http://thedefaultthumb.com'
    end
  end

  def cover_art
    if self.cover_urls
      JSON.parse(self.cover_urls)['max133w']
    end
  end

  def name_exerpt
    name = self.name
    if name.size > 41
      "#{name[0..38]}..."
    else
      name
    end
  end

  def play!
    plays_history = JSON.parse(self.plays_history)

    hour_plays = plays_history.first + 1
    plays_history[0] = hour_plays

    self.plays_history = plays_history.to_json
    self.save
  end

  def update_plays!
    plays_history = JSON.parse(self.plays_history)

    hour_plays = plays_history.first
    _plays_history = plays_history.unshift(0)[0..168]

    weekly_plays = 0  # Trending
    daily_plays = 0   # Hot

    _plays_history.each{|i|weekly_plays+=i}
    plays_history[1..24].each{|i|daily_plays+=i}

    self.plays_count += hour_plays

    self.plays_weekly_count = weekly_plays
    self.plays_daily_count = daily_plays

    self.plays_history = _plays_history.to_json
    self.save
  end

  def create_searchable_meta
    meta = ''

    self.tracks.each{|track| meta += "#{track.name} #{track.artist} ".downcase}
    self.searchable_metadata = meta
    self.save
  end

  def calc_duration
    duration = 0

    self.tracks.each{|track| duration += track.duration if track.duration}
    self.duration = duration
    self.save
  end

  def self.popular_mixes
    Mix.find(:all, :order => 'plays_weekly_count DESC', :limit => 8)
  end
  def self.hot_mixes
    Mix.find(:all, :order => 'plays_daily_count DESC', :limit => 8)
  end
  def self.new_mixes
    Mix.find(:all, :order => 'id DESC', :limit => 8)
  end

  def related_tracks
    mix_ids = []
    self.tags.map do |t|
      mix_ids += t.mixes.map(&:id)
    end
    mix_ids.uniq!

    results = []
    results += Mix.find_all_by_id(mix_ids, :order => 'plays_weekly_count DESC', :limit => 10)
    results += Mix.find_all_by_id(mix_ids, :conditions => ['id not in (?)', results.map(&:id)], :order => 'plays_daily_count DESC', :limit => 10)
    results += Mix.find_all_by_id(mix_ids, :conditions => ['id not in (?)', results.map(&:id)], :order => 'plays_count', :limit => 10)
  end

  def self.search_by_tags(tags)
    mix_ids = []
    tags.map do |t|
      mix_ids += t.mixes.map(&:id)
    end
    mix_ids.uniq!

    results = []
    results += Mix.find_all_by_id(mix_ids, :order => 'plays_weekly_count DESC', :limit => 10)
    results += Mix.find_all_by_id(mix_ids, :conditions => ['id not in (?)', results.map(&:id)], :order => 'plays_daily_count DESC', :limit => 10)
    results += Mix.find_all_by_id(mix_ids, :conditions => ['id not in (?)', results.map(&:id)], :order => 'plays_count', :limit => 10)
  end

  def self.search_by_keyword(query)
    Mix.find(:all, :conditions => ['searchable_metadata LIKE ?', "%#{query.downcase}%"])
  end
end
