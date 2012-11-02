class QueueShareTrack
  @queue = :low

  def self.perform(track_id)
    if (track = Track.find_by_id(track_id))
      message = "Checkout #{track.artist} new track \"#{track.title}\" featured on turnchannel"
      HTTParty.post 'https://api.bufferapp.com/1/updates/create.json?access_token=1/6538074d7e3ff8fe02a8d458c3071390', :body => {
        :text => "#{message} http://turnchannel.com/tracks/#{track.permalink}",
        :profile_ids => ['506ba34c1b81f6393c00001a', '506ba3061b81f6513c00001e'],
        :now => true
      }

      #Twitter.configure do |config|
      #  config.consumer_key = 'X92XlCMfrWeKRHTaf8OqDQ'
      #  config.consumer_secret = 'HXQiwryle9f24spswATXGxGR1uGwbjIOiOxidG5HQ'
      #  config.oauth_token = '820335812-qCGL4J05O0cxiNtznNNbqN5WX3sj6C6h4TUZr0gV'
      #  config.oauth_token_secret = 'WJikgLBDNlTUsR26xVQNvu58c2mrH5WkQBkCsFHeEM'
      #end

      #Twitter.update("#{message} http://turnchannel.com/tracks/#{track.permalink}");
    end
  end
end
