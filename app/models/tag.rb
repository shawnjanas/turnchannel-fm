class Tag < ActiveRecord::Base
  attr_accessible :name

  has_many :mix_tag_assignments
  has_many :mixes, :through => :mix_tag_assignments
end
