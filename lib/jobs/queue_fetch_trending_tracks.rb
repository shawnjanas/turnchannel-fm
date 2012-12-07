require 'beatport/client'

class QueueFetchTrendingTracks
  @queue = :high

  def self.perform
    client = BeatPortClient.new
    Genre.all.each do |genre|
      if (tracks = client.most_popular(genre.remote_genre_id))
        tracks.each do |track_hash|
          unless (track = Track.find_by_remote_track_id(track_hash['id']))
            artists_hash = client.artists(track_hash['artists'].map{|artist| artist['id']})
            label_hash = client.labels(track_hash['label']['id']).first

            artists = artists_hash.map{|artist_hash| Artist.build(:bp, artist_hash)}
            label = Label.build(:bp, label_hash)

            track = Track.build(:bp, genre, artists, label, track_hash)
          end
        end
      end
    end
  end
end
