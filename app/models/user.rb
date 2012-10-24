class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  #has_secure_password

  before_save :downcase_email#, :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :presence => true,
                    :format => { :with => VALID_EMAIL_REGEX },
                    :uniqueness => { :case_sensitive => false }

  #validates :password, :presence => true, :length => { :minimum => 6 }
  #validates :password_confirmation, :presence => true

  def downcase_email
    self.email.downcase!
  end

  def submit_track(sc_url)
    track = nil

    client = Soundcloud.new(:client_id => 'e3216af75bcd70ee4e5d91a6b9f1d302')
    if sc_url.is_a? String
      # call the resolve endpoint with a track url
      track = client.get('/resolve', :url => sc_url)
    else
      track = sc_url
    end

    Track.build(track)
  end

private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
