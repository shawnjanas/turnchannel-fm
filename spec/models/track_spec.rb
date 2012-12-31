require 'spec_helper'

describe Track do
  describe '#play!' do
    before do
      @track = FactoryGirl.build(:track)

      @user_id = 1
      @user = mock('User')
      @user.stubs(:id).returns(@user_id)

      @time = Time.now
      Time.stubs(:now).returns(@time)

      @ip_address = '102.0.0.1'
    end

    context 'given user and ip address' do
      it "should be valid play" do
        @user.expects(:play_track).with(@track)
        Play.expects(:create).with(:track_id => @track.id, :user_id => @user_id, :date => @time.to_i, :ip_address => @ip_address)

        @track.play!(@user, @ip_address)
      end
    end

    context 'given ip address and no user' do
      it "should be valid play" do
        @user.expects(:play_track).with(@track).times(0)
        Play.expects(:create).with(:track_id => @track.id, :user_id => nil, :date => @time.to_i, :ip_address => @ip_address)

        @track.play!(nil, @ip_address)
      end
    end

    context 'given user and no ip address' do
      it "should an invalid play" do
        @user.expects(:play_track).with(@track).times(0)
        Play.expects(:create).with(:track_id => @track.id, :user_id => @user_id, :date => @time.to_i, :ip_address => nil).times(0)

        @track.play!(@user, '').should eql false
      end
    end
  end

  describe '#update_plays' do
    before do
      @track = FactoryGirl.build(:track)

      @redis = stub('redis')
      Resque.stubs(:redis).returns(@redis)

      @plays = 12
      @play = mock('Play')
      @play.stubs(:plays).returns(@plays)

      @redis.expects(:lpush).with("track:#{@track.id}:hourly_plays", @play.plays)
      @redis.expects(:ltrim).with("track:#{@track.id}:hourly_plays", 0, 167)
    end

    context 'given 3 hourly plays' do
      before do
        @hourly_plays = [4,5,7]
      end

      it "should update plays" do
        @redis.expects(:lrange).with("track:#{@track.id}:hourly_plays", 0, -1).returns(@hourly_plays)

        @track.update_plays!(@play)
        @track.plays.should eql 12
        @track.daily_plays.should eql 16
        @track.weekly_plays.should eql 16
      end
    end

    context 'given 168 hourly plays' do
      before do
        @hourly_plays = [12] + (0..166).to_a.map{|i| 2}
      end

      it "should update plays" do
        @redis.expects(:lrange).with("track:#{@track.id}:hourly_plays", 0, -1).returns(@hourly_plays)

        @track.update_plays!(@play)
        @track.plays.should eql 12
        @track.daily_plays.should eql 58
        @track.weekly_plays.should eql 346
      end
    end
  end
end
