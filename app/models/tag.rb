class Tag < ActiveRecord::Base
  attr_accessible :name

  has_many :tracks
  has_many :forums
end
