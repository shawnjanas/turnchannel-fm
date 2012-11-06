require '8tracks/client.rb'

class QueueFetchPopular8TracksMixes
  @queue = :low

  def self.perform
    client = EightTracksClient.new(:api_key => '7bddbb8622d28ae3ec1812d4472f4cb64937d530')

    mixes_hash = client.mixes(:sort => 'popular', :per_page => 100)

    mixes_hash.each do |mix_hash|
      mix_id = mix_hash['id'].to_s
      unless Mix.find_by_remote_id(mix_id)
        Resque.enqueue(QueueParse8TracksMix, mix_id)
        break
      end
    end
  end
end
