class Track < ActiveRecord::Base
  attr_accessible :title, :full_title, :plays, :cached_plays, :sc_url, :sc_id, :artwork_url, :purchase_url, :description, :duration, :label_name, :artist, :genre_id, :created_at, :user_id, :tag_id

  has_permalink :full_title

  belongs_to :tag

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
