require 'beatport/client'

class QueueFetchNewBpTracks
  @queue = :high

  def self.perform
    user = User.find_by_id(1)

    Forum.where(:source => 'bp').each do |forum|
      client = BeatPortClient.new
      tracks = client.most_popular(forum.remote_id)

      tracks.each_with_index do |track, i|
        track_obj = user.submit_track('bp', forum.tag, track)
        #Resque.enqueue(QueueShareTrack, track_obj.id) if Rails.env.production?

        break if i == 10
      end

      forum.last_fetch = Time.now
      forum.save
      break
    end
  end
end
