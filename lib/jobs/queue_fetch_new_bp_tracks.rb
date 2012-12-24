require 'beatport/client'

class QueueFetchNewBpTracks
  @queue = :high

  def self.perform
    user = User.find_by_id(1)

    Forum.where(:source => 'bp').each do |forum|
      client = BeatPortClient.new
      tracks = client.most_popular(forum.remote_id, :per_page => 40)

      tracks.each_with_index do |track, i|
        track_obj = user.submit_track('bp', forum.tag, track)
      end

      forum.last_fetch = Time.now
      forum.save
    end
  end
end
