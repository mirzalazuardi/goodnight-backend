require 'rails_helper'

RSpec.describe Sleep, type: :model do
  subject { Sleep }
  let(:user) { create :user }

  shared_examples 'new sleep cycle' do |result|
    it "has #{result} row(s)" do
      expect(subject.count).to eq result
    end

    it 'has start value' do
      expect(subject.last.start).not_to eq nil
    end
    it 'has no finish' do
      expect(subject.last.finish).to eq nil
    end
    it 'has no duration seconds value' do
      expect(subject.last.duration_seconds).to eq nil
    end
  end

  shared_examples 'human readable time' do |sec, result|
    it result do
      expect(subject.human_readable_time(sec)).to eq result
    end
  end

  describe '.clock' do
    before do
      subject.clock(user.id)
    end

    context 'sleep start' do
      it_behaves_like "new sleep cycle", 1
    end

    context 'sleep finish' do
      before do
        Timecop.freeze(Time.now + 1.hour)
        subject.clock(user.id)
      end

      it 'has still a row' do
        expect(subject.count).to eq 1
      end
      it 'has start value' do
        expect(subject.first.start).not_to eq nil
      end
      it 'has finish value' do
        expect(subject.first.finish).not_to eq nil
      end
      it 'has duration seconds value' do
        expect(subject.first.duration_seconds).to be == 3600
      end

      context 'begin a new sleep cycle(row)' do
        before do
          Timecop.return
          subject.clock(user.id)
        end
        it_behaves_like "new sleep cycle", 2
      end
    end
  end

  describe '.human_readable_time' do
    context 'calculations' do
      it_behaves_like 'human readable time', 1, "1 second"
      it_behaves_like 'human readable time', 2, "2 seconds"
      it_behaves_like 'human readable time', 60, "1 minute"
      it_behaves_like 'human readable time', 120, "2 minutes"
      it_behaves_like 'human readable time', 3600, "1 hour"
      it_behaves_like 'human readable time', 7200, "2 hours"
      it_behaves_like 'human readable time', 86400, "1 day"
      it_behaves_like 'human readable time', 172800, "2 days"
      it_behaves_like 'human readable time', 1872981,
        "21 days, 16 hours, 16 minutes, 21 seconds"
      it_behaves_like 'human readable time',31536000 , "365 days"
      end
    end
end
