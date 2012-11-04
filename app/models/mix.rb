class Mix < ActiveRecord::Base
  attr_accessible :name, :source, :remote_id, :description, :plays, :permalink, :user_id

  validates :remote_id, :presence => true, :uniqueness => true
  validates_presence_of :name, :source, :permalink, :user_id

  has_permalink :name

  has_many :mix_tag_assignments
  has_many :tags, :through => :mix_tag_assignments

  has_many :track_mix_assignments
  has_many :tracks, :through => :track_mix_assignments

  def toggle_fav(user)
    1
  end
end
