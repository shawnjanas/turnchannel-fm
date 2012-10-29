class Forum < ActiveRecord::Base
  attr_accessible :name, :remote_id, :last_fetch

  has_many :forum_playlist_assignments
  has_many :playlists, :through => :forum_playlist_assignments

  before_save :validate_remote_id

  def validate_remote_id
    client = Soundcloud.new(:client_id => 'e3216af75bcd70ee4e5d91a6b9f1d302')
    user = client.get("/users/#{self.remote_id}")

    if user
      self.name = user.username
    else
      self.destroy
    end
  end
end
