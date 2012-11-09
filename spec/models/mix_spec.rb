require 'spec_helper'

describe Mix do
  describe '#update_plays' do
    describe 'empty play history' do
      before do
        @mix = Mix.new
        @plays_history = '[0]'
        @mix.stubs(:plays_history).returns(@plays_history)
      end

      it 'should update plays stats' do
        @mix.update_plays!

        assert_equal 0 ,@mix.plays_count
        assert_equal 0 ,@mix.plays_weekly_count
        assert_equal 0 ,@mix.plays_daily_count
        assert_equal '[0,0]' ,@mix.plays_history
      end
    end
  end
end
