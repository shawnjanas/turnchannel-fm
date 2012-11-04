class Track < ActiveRecord::Base
  attr_accessible :title, :plays, :source, :remote_id, :buy_link, :duration, :thumbnails

  validates :remote_id, :presence => true, :uniqueness => true
  validates_presence_of :title, :source

  has_many :track_mix_assignments
  has_many :mixes, :through => :track_mix_assignments
end
