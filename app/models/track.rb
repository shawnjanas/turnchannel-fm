class Track < ActiveRecord::Base
  attr_accessible :source, :name, :mix_name, :title, :slug, :isrc, :release_date, :purchase_url, :images, :duration, :yt_remote_id, :yt_artwork_url, :plays_count, :remote_track_id, :label_id, :searchable_meta

  has_many :genre_track_assignments
  has_many :genres, :through => :genre_track_assignments

  has_many :artist_track_assignments
  has_many :artists, :through => :artist_track_assignments

  belongs_to :label

  validates :title, :presence => true
  validates :yt_remote_id, :presence => true, :uniqueness => true

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

  def cover_art
    JSON.parse(self.images)['large']['url']
  end

  def self.build(source, genre, artists, label, track_hash)
    if source == :bp
      unless (track = Track.find_by_remote_track_id(track_hash['id']))
        duration_list = track_hash['length'].split(':')
        track_duration = duration_list.first.to_i * 60 + duration_list.last.to_i

        track = Track.new(
          :source => 'bp',
          :name => track_hash['name'],
          :mix_name => track_hash['mixName'],
          :title => track_hash['title'],
          :slug => track_hash['slug'],
          :isrc => track_hash['isrc'],
          :release_date => track_hash['releaseDate'],
          :purchase_url => "http://www.beatport.com/track/#{track_hash['slug']}/#{track_hash['id']}",
          :images => track_hash['images'].to_json,
          :duration => track_duration,
          :remote_track_id => track_hash['id'],
          :label_id => label.id
        )
        track.find_youtube_video!(artists)
        unless track.new_record?
          artists.each do |artist|
            ArtistTrackAssignment.create(
              :artist_id => artist.id,
              :track_id => track.id,
            )
          end
        end
      end
    end
  end

  def find_youtube_video!(artists)
    title = "#{artists.first.name} - #{self.name}"

    puts "TITLE => #{title}"

    client = YouTubeIt::Client.new
    if (res = client.videos_by(:query => title))
      if (videos = res.videos)
        videos.each do |video|
          if (self.duration - video.duration).abs < 10
            self.yt_remote_id = video.unique_id
            #self.yt_artwork_url = video.unique_id
            self.save
            break
          end
        end
      end
    end
    self
  end
end
