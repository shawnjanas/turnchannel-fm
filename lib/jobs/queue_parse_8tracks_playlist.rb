require '8tracks/client.rb'

class QueueParse8TracksMix
  @queue = :high

  def self.perform(mix_id)
    mix_id = mix_id.to_s
    client = EightTracksClient.new(:api_key => '7bddbb8622d28ae3ec1812d4472f4cb64937d530')

    # Fetch mix info
    mix_hash = client.mix(mix_id)
    if mix_hash
      # Create the mix
      unless (mix = Mix.find_by_remote_id(mix_id))
        user = User.first
        mix = Mix.create(
          :user_id => user.id,
          :name => mix_hash['name'],
          :source => '8tracks',
          :remote_id => mix_id,
          :description => mix_hash['description']
        )
      end

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
        unless track_hash['you_tube_id'].blank?
          unless (track = Track.find_by_remote_id(track_hash['you_tube_id']))
            yt_client = YouTubeIt::Client.new
            video = yt_client.video_by(track_hash['you_tube_id'])
            if !video.blank? && video.access_control['embed'] == 'allowed'
              track = Track.create(
                :buy_link => track_hash['buy_link'],
                :source => 'youtube',
                :remote_id => track_hash['you_tube_id'],
                :title => video.title,
                :duration => video.duration,
                :thumbnails => video.thumbnails.to_json,
              )
            else
              next
            end
          end

          unless (track_mix_assign = TrackMixAssignment.where(:track_id => track.id, :mix_id => mix.id).first)
            track_mix_assign = TrackMixAssignment.create(:track_id => track.id, :mix_id => mix.id)
          end
        end
      end
    end
  end
end
