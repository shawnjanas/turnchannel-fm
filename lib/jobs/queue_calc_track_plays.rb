class QueueCalcTrackPlays
  @queue = :low

  def self.perform
    Play.calc_track_plays
  end
end
