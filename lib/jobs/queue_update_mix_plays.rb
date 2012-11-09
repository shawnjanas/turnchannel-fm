class QueueUpdateMixPlays
  @queue = :high

  def self.perform
    Mix.all.each{|mix| mix.update_plays!}
  end
end

