class Mix < ActiveRecord::Base
  attr_accessible :name, :source, :remote, :description, :plays_count, :likes_count, :permalink, :cover_urls, :published, :first_published_at, :user_id

  validates :remote, :presence => true, :uniqueness => true
  validates_presence_of :name, :source, :permalink, :user_id

  has_permalink :name

  belongs_to :user

  has_many :mix_tag_assignments
  has_many :tags, :through => :mix_tag_assignments

  has_many :track_mix_assignments
  has_many :tracks, :through => :track_mix_assignments

  has_many :favorite_mixes
  has_many :users_favorite, :through => :favorite_mixes

  def toggle_fav(user)
    if (favorite_mix = FavoriteMix.find_by_user_id_and_mix_id(user.id, self.id))
      favorite_mix.destroy
      0
    else
      FavoriteMix.create(:user_id => user.id, :mix_id => self.id)
      1
    end
  end

  def thumbnail
    tracks = self.tracks.where("remote IS NOT NULL").limit(4)
    if tracks.size == 4
      tracks.map do |track|
        track.thumbnail
      end
    elsif tracks.size > 0
      tracks.first.thumbnail
    else
      'http://thedefaultthumb.com'
    end
  end

  def cover_art
    if self.cover_urls
      JSON.parse(self.cover_urls)['max133w']
    end
  end

  def name_exerpt
    name = self.name
    if name.size > 21
      "#{name[0..18]}..."
    else
      name
    end
  end

  def play
    self.plays_count = self.plays_count + 1
    self.save
  end
end
