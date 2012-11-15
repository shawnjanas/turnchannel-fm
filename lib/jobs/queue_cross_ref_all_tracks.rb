class QueueCrossRefAllTracks
  @queue = :low

  def self.perform
    Track.all.each{|track| track.find_youtube_video!}
  end
end
