class MixTagAssignment < ActiveRecord::Base
  attr_accessible :mix_id, :tag_id

  belongs_to :mix
  belongs_to :tag
end
