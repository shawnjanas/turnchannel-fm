class Track < ActiveRecord::Base
  attr_accessible :name, :artist, :album_release_name, :year, :source, :remote, :buy_link, :buy_icon, :duration, :thumbnails, :published, :first_published_at, :plays_count

  validates_presence_of :name, :artist, :source

  before_save :resolve_remote

  has_many :track_mix_assignments
  has_many :mixes, :through => :track_mix_assignments

  def thumbnail
    if self.thumbnails
      JSON.parse(self.thumbnails).first['url']
    else
      "No Thumbnail"
    end
  end

  def resolve_remote
    puts 'resolve_remote'
    if !self.remote.blank? && self.thumbnails.blank?
      puts self.remote
      unless (track = Track.find_by_remote(self.remote))
        puts track.inspect
        yt_client = YouTubeIt::Client.new
        begin
          video = yt_client.video_by(self.remote)

          if !video.blank? && video.access_control['embed'] == 'allowed'
            self.duration = video.duration
            self.thumbnails = video.thumbnails.to_json
            self.save
          end
        rescue => e
          puts "Error: #{e}"
        end
      else
        self.track_mix_assignments.each do |x|
          x.track_id = track.id
          x.save
        end
        self.remote = nil
      end
    end
  end
end
