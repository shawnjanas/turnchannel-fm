class Track < ActiveRecord::Base
  attr_accessible :title, :full_title, :plays, :cached_plays, :sc_url, :sc_id, :artwork_url, :purchase_url, :description, :duration, :label_name, :artist, :genre_id, :created_at, :user_id, :tag_id, :searchable_metadata

  has_permalink :full_title

  belongs_to :tag
  belongs_to :user

  has_many :track_likes
  has_many :liked_users, :through => :track_likes

  has_many :track_dislikes
  has_many :disliked_users, :through => :track_dislikes

  validates :sc_url, :presence => true, :uniqueness => true

  before_save :parse_title

  def self.build(user_id, tag, track_hash)
    if track_hash
      if track_hash.stream_url && track_hash.artwork_url
        track = Track.create(
          :full_title => track_hash.title,
          :sc_url => track_hash.permalink_url,
          :sc_id => track_hash.id,
          :artwork_url => track_hash.artwork_url,
          :purchase_url => track_hash.purchase_url,
          :description => track_hash.description,
          :duration => track_hash.duration,
          :plays => 0,
          :cached_plays => 0,
          :user_id => user_id,
          :tag_id => tag.id
        )
      end
    else
      throw :invalid_track
    end
  end

  def play
    self.plays = self.plays + 1
    self.cached_plays = self.cached_plays + 1
    self.save
  end

  def parse_title
    title, *rest = self.full_title.split(/ by /)

    self.title = title
    _rest = rest.join(' by ')
    self.artist = _rest.split(/ - /).first
    self.full_title = self.full_title.downcase
  end

  def f_full_title
    "#{self.f_title} by #{self.f_artist}"
  end

  def f_title
    if self.title
      self.title.split(" ").map{|t| t.capitalize}.join(' ')
    else
      ""
    end
  end

  def f_artist
    if self.artist
      self.artist.split(" ").map{|t| t.capitalize}.join(' ')
    else
      ""
    end
  end

  def toggle_like(user)
    if (track_like = TrackLike.find_by_user_id_and_track_id(user.id, self.id))
      track_like.destroy
      0
    else
      TrackLike.create(:user_id => user.id, :track_id => self.id)

      if (track_dislike = TrackDislike.find_by_user_id_and_track_id(user.id, self.id))
        track_dislike.destroy
        2
      else
        1
      end
    end
  end

  def toggle_dislike(user)
    if (track_dislike = TrackDislike.find_by_user_id_and_track_id(user.id, self.id))
      track_dislike.destroy
      0
    else
      TrackDislike.create(:user_id => user.id, :track_id => self.id)

      if (track_like = TrackLike.find_by_user_id_and_track_id(user.id, self.id))
        track_like.destroy
        2
      else
        1
      end
    end
  end

  def find_youtube_video!
    title = self.full_title

    client = YouTubeIt::Client.new

    if (res = client.videos_by(:query => title))
      if (videos = res.videos)
        if (video = videos.first)
          if (self.duration/1000 - video.duration).abs < 10
            return "http://www.youtube.com/watch?v=#{video.unique_id}"
          end
        end
      end
    end

    nil
  end
end
