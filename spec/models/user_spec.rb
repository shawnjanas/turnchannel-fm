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
end
