class Track < ActiveRecord::Base
  store :metadata, accessors: [ :remote_url, :remote_id, :artwork_url ]
  attr_accessible :user_id, :source, :remote_id, :remote_url

  after_save :resolve_track_data

  belongs_to :user
  has_and_belongs_to_many :categories

  SOURCE = {:soundcloud => 0}

private
  def resolve_track_data
    client = Soundcloud.new :client_id => Network[:soundcloud][:client_id]

    track = client.get('/resolve', :url => self.remote_url)

    self.remote_id = track.id
    self.artwork_url = track.artwork_url if track.artwork_url
  end
end
