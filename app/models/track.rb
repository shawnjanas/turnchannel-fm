class Track < ActiveRecord::Base
  attr_accessible :source, :title, :full_title, :plays, :cached_plays, :sc_url, :sc_id, :artwork_url, :purchase_url, :description, :duration, :label_name, :artist, :genre_id, :created_at, :user_id, :tag_id, :searchable_metadata, :raw_data, :published

  has_permalink :full_title

  belongs_to :tag
  belongs_to :user

  has_many :track_likes
  has_many :liked_users, :through => :track_likes

  has_many :track_dislikes
  has_many :disliked_users, :through => :track_dislikes

  #validates :sc_url

  before_save :parse_title

  def self.build(user_id, source, tag, track_hash)
    if track_hash
      if source == 'sc'
        if track_hash.stream_url && track_hash.artwork_url
          track = Track.create(
            :source => source,
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
            :tag_id => tag.id,
            :raw_data => track_hash.to_json,
            :published => true
          )
        end
      elsif source == 'bp'
        track = Track.new(
          :source => source,
          :full_title => "#{track_hash['artists'][0]['name']} - #{track_hash['name']} #{track_hash['mixName']}",
          :title => track_hash['name'],
          :artist => track_hash['artists'][0]['name'],
          :sc_url => nil,
          :sc_id => nil,
          :artwork_url => track_hash['images']['large']['url'],
          :purchase_url => "http://www.beatport.com/track/#{track_hash['slug']}/#{track_hash['id']}",
          :description => nil,
          :duration => self.parse_time(track_hash['length']) * 1000,
          :plays => 0,
          :cached_plays => 0,
          :user_id => user_id,
          :tag_id => tag.id,
          :raw_data => track_hash.to_json,
          :published => false
        )
        #track.find_soundcloud_track!
        track.save
        puts track.errors.inspect
      end
    else
      throw :invalid_track
    end
  end

  def self.parse_time(time)
    time_a = time.split(':')

    if time_a.size == 3
      time_a[0].to_i * 60 * 60 + time_a[1].to_i * 60 + time_a[2].to_i
    elsif time_a.size == 2
      time_a[0].to_i * 60 + time_a[1].to_i
    else
      time
    end
  end

  def play
    self.plays = self.plays + 1
    self.cached_plays = self.cached_plays + 1
    self.save
  end

  def parse_title
    if self.source == 'sc'
      title, *rest = self.full_title.split(/ by /)

      self.title = title
      _rest = rest.join(' by ')
      self.artist = _rest.split(/ - /).first
      self.full_title = self.full_title.downcase
    end
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

  def find_soundcloud_track!
    title = self.title
    artist = self.artist

    full_title = self.full_title

    client = Soundcloud.new(:client_id => 'e3216af75bcd70ee4e5d91a6b9f1d302')
    tracks = client.get('/tracks', :q => title, :'duration[from]' => self.duration-5000, :'duration[to]' => self.duration+5000)

    tracks.each do |track|
      puts 'track'
      puts full_title

      valid = true
      track_title = track.title.downcase

      puts track_title

      puts "T: #{title}"
      title.downcase.split(' ').each do |token|
        unless track_title.include? token
          valid = false
          puts token
        end
      end

      puts "A: #{artist}"
      artist.downcase.split(' ').each do |token|
        unless track_title.include? token
          valid = false
          puts token
        end
      end

      puts valid

      if valid
        self.sc_url = track.permalink_url
        self.sc_id = track.id
        self.description = track.description || ''
        self.save

        break
      end
    end

    nil
  end
end
