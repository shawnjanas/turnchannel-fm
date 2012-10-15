class Track < ActiveRecord::Base
  store :metadata, accessors: [ :remote_url, :remote_id, :artwork_url ]
  attr_accessible :user_id, :source, :title, :artist, :remote_id, :remote_url

  after_create :resolve_track_data

  belongs_to :user
  has_and_belongs_to_many :categories

  SOURCE = {:soundcloud => 0}

  def self.recent(genre)
    sc_id = 5614319 #house

    if genre == 'house'
      sc_id = 5614319
    elsif genre == 'dubstep'
      sc_id = 3158948
    elsif genre == 'dnb'
      sc_id = 12104873
    elsif genre == 'electro'
      sc_id = 5614319
    end

    client = Soundcloud.new :client_id => 'e3216af75bcd70ee4e5d91a6b9f1d302'

    tracks = []
    page_size = 100

    (0..0).to_a.each do |i|
      offset = i * page_size
      tracks += client.get("/users/#{sc_id}/tracks", :order => 'created_at', :offset => offset, :limit => page_size)
    end

    tracks.find_all do |track|
      track.streamable && track.duration < 600000
    end
  end

private
  def resolve_track_data
    client = Soundcloud.new :client_id => Network[:soundcloud][:client_id]

    track = client.get('/resolve', :url => self.remote_url)
    if track.stream_url
      self.title = track.title
      self.artist = track.user.username
      self.remote_id = track.id
      self.artwork_url = track.artwork_url if track.artwork_url
      self.save
    else
      self.destroy
    end
  end
end
