class QueueScTop40
  @queue = :high

  def self.perform
    redis = Resque.redis
    user = User.find_by_id(1)

    Tag.all.each do |tag|
      client = Soundcloud.new(:client_id => 'e3216af75bcd70ee4e5d91a6b9f1d302')
      raw_tracks = client.get("/tracks", :order => 'hotness', :tags => tag.name, :limit => 40, :filter => 'streamable')

      unless raw_tracks.blank?
        redis.del("tag:#{tag.name}:top40")
        raw_tracks.each do |raw_track|
          track = user.submit_track(tag, raw_track)
          redis.rpush("tag:#{tag.name}:top40", track.id) unless track.blank?
        end
      end
    end
  end
end
