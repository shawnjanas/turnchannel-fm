class FavoriteMix < ActiveRecord::Base
  attr_accessible :user_id, :mix_id

  belongs_to :mix
  belongs_to :user
end
