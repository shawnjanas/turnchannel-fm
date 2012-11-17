class QueueNewTracks
  @queue = :high

  def self.perform
    user = User.find_by_id(1)

    Forum.all.each do |forum|
      tracks = QueueNewTracks.fetch_tracks(user, forum)

      tracks.reverse.each_with_index do |track, i|
        track_obj = user.submit_track(forum.tag, track)
        Resque.enqueue(QueueShareTrack, track_obj.id) if i < 5 && Rails.env.production?
      end

      forum.last_fetch = Time.now
      forum.save
    end
  end

  def self.fetch_tracks(user, forum, options = {})
    limit = 10
    offset = options[:offset] || 0
    track_list = options[:track_list] || []

    if forum.last_fetch.blank?
      limit = 50
    end

    skip = false

    client = Soundcloud.new(:client_id => 'e3216af75bcd70ee4e5d91a6b9f1d302')
    tracks = client.get("/users/#{forum.remote_id}/tracks", :order => 'created_at', :offset => offset, :limit => limit)

    skip = true if tracks.length == 0

    tracks.each do |track|
      if !forum.last_fetch.blank? && forum.last_fetch > track.created_at
        skip = true
        break
      end
      track_list << track
    end

    QueueNewTracks.fetch_tracks(user, forum, :offset => offset + limit, :track_list => track_list) unless skip

    track_list
  end
end
