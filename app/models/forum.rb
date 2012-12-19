class Forum < ActiveRecord::Base
  attr_accessible :name, :source, :remote_id, :last_fetch, :tag_id

  belongs_to :tag

  before_save :validate_remote_id

  def validate_remote_id
    if self.source == 'sc'
      client = Soundcloud.new(:client_id => 'e3216af75bcd70ee4e5d91a6b9f1d302')
      user = client.get("/users/#{self.remote_id}")

      if user
        self.name = user.username
      else
        self.destroy
      end
    end
  end
end
