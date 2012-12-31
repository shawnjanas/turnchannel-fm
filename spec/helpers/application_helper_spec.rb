require 'spec_helper'

describe ApplicationHelper do
  describe '#normalize_time' do
    before do
      # 1356753362
      @time = Time.parse('2012-12-28 22:56:02 -0500')
      Time.stubs(:now).returns(@time)
    end

    context 'given offset' do
      before do
        @offset = 60*60
      end

      it 'should normalize time' do
        helper.normalize_time(@offset).should eql [1356750000, 1356746400]
      end
    end
  end
end
