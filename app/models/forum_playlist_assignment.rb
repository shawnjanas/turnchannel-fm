class ForumPlaylistAssignment < ActiveRecord::Base
  attr_accessible :forum_id, :playlist_id

  belongs_to :forum
  belongs_to :playlist
end
