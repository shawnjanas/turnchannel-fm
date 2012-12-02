class QueueShareTrack
  @queue = :low

  def self.perform(track_id)
    if (track = Track.find_by_id(track_id))
      message = "Checkout #{track.artist} new track \"#{track.title}\" featured on TurnChannel"
      HTTParty.post 'https://api.bufferapp.com/1/updates/create.json?access_token=1/6538074d7e3ff8fe02a8d458c3071390', :body => {
        :text => "#{message} http://turnchannel.com/tracks/#{track.permalink}",
        :profile_ids => ['506ba34c1b81f6393c00001a', '506ba3061b81f6513c00001e'],
        :now => true,
        :shorten => false,
      }

      #sc = track.description.match(/http\:\/\/soundcloud\.com\/+.*\r/)

      handles = []
      if (raw_tw = track.description.scan(/twitter\.com\/.*/))
        raw_tw.each do |tw|
          handles << tw.split('/').last.strip!
        end
      end

      unless handles.empty?
        message = ''
        handles.each do |handle|
          message += "@#{handle} "
        end

        message += "Hey man. Your track was featured on TurnChannel. Lovin' your music. Just thought we would let you know."
        HTTParty.post 'https://api.bufferapp.com/1/updates/create.json?access_token=1/6538074d7e3ff8fe02a8d458c3071390', :body => {
          :text => "#{message} http://turnchannel.com/tracks/#{track.permalink}",
          :profile_ids => ['506ba3061b81f6513c00001e'], # Only Twitter
          :now => true,
          :shorten => false,
        }
      end

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
