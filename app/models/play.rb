class Play
  include Mongoid::Document

  field :track_id, :type => Integer
  field :user_id, :type => Integer
  field :ip_address, :type => String
  field :date, :type => Integer

  def self.calc_track_plays
    from_time, to_time = normalize_time(60*60)
    plays = Play.grouped_plays

    plays.each do |play|
      unless (track = Track.find_by_id(play.track_id))
        track.update_plays! play
      end
    end
  end

  def self.grouped_plays
    Play.group(
      :key => {:track_id => true},
      :cond => {:date.gte => from_time, :date.lte => to_time},
      :reduce => 'function(a,b){b.plays++;}',
      :initial => {:plays => 0}
    )
  end
end
