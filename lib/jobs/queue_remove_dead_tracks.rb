class QueueRemoveDeadTracks
  @queue = :low

  def self.perform
    client = Soundcloud.new(:client_id => 'e3216af75bcd70ee4e5d91a6b9f1d302')
    #Track.all.each do |track|
    #  begin
    #    client.get("/tracks/#{track.sc_id}")
    #  rescue Soundcloud::ResponseError => e
    #    puts e
    #    #track.destroy if e.response.code == 404
    #  end
    #end
    begin
      client.get("/tracks/61728858")
    rescue Soundcloud::ResponseError => e
      puts e.response.code
      #track.destroy if e.response.code == 404
    end
  end
end
