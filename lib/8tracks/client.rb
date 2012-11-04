class EightTracksClient
  def initialize(options)
    throw ":api_key required" if options[:api_key].blank?
    @api_key = options[:api_key]
    play_token
  end

  def play_token
    @play_token ||= fetch_play_token
  end

  def mix(mix_id)
    query("/mixes/#{mix_id}.json?")['mix']
  end

  def tracks(mix_id, options = {:start => true})
    tracks = options[:tracks] || []

    action = 'next'
    if options[:start]
      action = 'play'
    end

    track = query("/sets/#{play_token}/#{action}.json?mix_id=#{mix_id}&")

    if track['set']['at_end'] == false
      tracks << track['set']['track']
      tracks = self.tracks(mix_id, :tracks => tracks, :start => false)
    end

    tracks
  end

  def fetch_play_token
    res = query('/sets/new.json?')
    res['play_token']
  end

  def query(url)
    puts "http://8tracks.com#{url}api_key=#{@api_key}"
    res = HTTParty.get("http://8tracks.com#{url}api_key=#{@api_key}")
    res.parsed_response
  end
end
