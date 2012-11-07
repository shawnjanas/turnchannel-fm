require '8tracks/client.rb'

class QueueParse8TracksMix
  @queue = :high

  def self.perform(mix_id)
    mix_id = mix_id.to_s
    client = EightTracksClient.new(:api_key => '7bddbb8622d28ae3ec1812d4472f4cb64937d530')

    return if Mix.find_by_remote(mix_id)

    # Fetch mix info
    mix_hash = client.mix(mix_id)
    if mix_hash
      # Create the mix
      user = User.first
      mix = Mix.create(
        :name => mix_hash['name'],
        :source => '8tracks',
        :remote => mix_id,
        :description => mix_hash['description'],
        :cover_urls => mix_hash['cover_urls'].to_json,
        :user_id => user.id,
        :published => false
      )

      # Create the tag assignemnts to the mix
      mix_hash['tag_list_cache'].split(', ').each do |tag_str|
        unless (tag = Tag.find_by_name(tag_str))
          tag = Tag.create(:name => tag_str)
        end

        unless (mix_tag_assign = MixTagAssignment.where(:tag_id => tag.id, :mix_id => mix.id).first)
          mix_tag_assign = MixTagAssignment.create(:tag_id => tag.id, :mix_id => mix.id)
        end
      end

      # Create the tracks for the mix
      tracks = client.tracks(mix_id)
      tracks.each do |track_hash|
        track = Track.new(
          :name => track_hash['name'],
          :artist => track_hash['performer'],
          :album_release_name => track_hash['release_name'],
          :year => track_hash['year'],
          :source => 'youtube',
          :remote => nil,
          :buy_link => track_hash['buy_link'],
          :buy_icon => track_hash['buy_icon'],
          :published => false
        )

        unless track_hash['you_tube_id'].blank?
          if Track.find_by_remote(track_hash['you_tube_id'])
            track = Track.find_by_remote(track_hash['you_tube_id'])
          else
            yt_client = YouTubeIt::Client.new
            begin
              video = yt_client.video_by(track_hash['you_tube_id'])

              if !video.blank? && video.access_control['embed'] == 'allowed'
                track.remote = track_hash['you_tube_id']
                track.duration = video.duration
                track.thumbnails = video.thumbnails.to_json
              end
            rescue => e
            end
          end
        end
        track.save!

        unless (track_mix_assign = TrackMixAssignment.where(:track_id => track.id, :mix_id => mix.id).first)
          track_mix_assign = TrackMixAssignment.create(:track_id => track.id, :mix_id => mix.id)
        end
      end
    end
  end
end
