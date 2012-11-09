class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :play_history

  has_many :mixes

  has_many :favorite_mixes
  has_many :mixes_favorite, :through => :favorite_mixes

  def play_mix(mix)
    play_history = JSON.parse(self.play_history)
    play_history = play_history.unshift(mix.id)[0..11]

    self.play_history = play_history.to_json
    self.save
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
end
