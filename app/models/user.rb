class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :token_authenticatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :play_history, :provider, :uid, :avatar

  has_many :track_likes
  has_many :liked_tracks, :through => :track_likes

  has_many :track_dislikes
  has_many :disliked_tracks, :through => :track_dislikes

  def downcase_email
    self.email.downcase!
  end

  def submit_track(tag, sc_url)
    track = nil

    client = Soundcloud.new(:client_id => 'e3216af75bcd70ee4e5d91a6b9f1d302')
    if sc_url.is_a? String
      # call the resolve endpoint with a track url
      track = client.get('/resolve', :url => sc_url)
    else
      track = sc_url
    end

    Track.build(self.id, tag, track)
  end

  def play_track(track)
    return unless track.instance_of? Track

    client = Resque.redis
    client.lpush("user:#{self.id}:play_history", track.id)
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      if (user = User.find_by_email(auth.info.email))
        user.uid = auth.uid
        user.provider = auth.provider
        user.avatar = auth.info.image
        user.save!
      else
        user = User.create(
          :name => auth.extra.raw_info.name,
          :avatar => auth.info.image,
          :provider => auth.provider,
          :uid => auth.uid,
          :email => auth.info.email,
          :password => Devise.friendly_token[0,20]
        )
      end
    end
    user
  end
end
