require 'rails_helper'

RSpec.describe Sleep, type: :model do
  subject { Sleep }
  let(:user) { create :user }

  describe '.clock' do
    before do
      subject.clock(user.id)
    end

    context 'sleep start' do
      it 'has a row' do
        expect(subject.count).to eq 1
      end
      it 'has start value' do
        expect(subject.first.start).not_to eq nil
      end
      it 'has no finish' do
        expect(subject.first.finish).to eq nil
      end
      it 'has no duration seconds value' do
        expect(subject.first.duration_seconds).to eq nil
      end
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

      context 'new sleep cycle(row)' do
        before do
          Timecop.return
          subject.clock(user.id)
        end
        it 'has 2 rows' do
          expect(subject.count).to eq 2
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
    end
  end

  describe '.human_readable_time' do
    context 'calculations' do
      it "1 second" do
        expect(subject.human_readable_time(1)).to eq "1 second"
      end
      it "2 seconds" do
        expect(subject.human_readable_time(2)).to eq "2 seconds"
      end
      it "1 minute" do
        expect(subject.human_readable_time(60)).to eq "1 minute"
      end
      it "2 minutes" do
        expect(subject.human_readable_time(120)).to eq "2 minutes"
      end
      it "1 hour" do
        expect(subject.human_readable_time(3600)).to eq "1 hour"
      end
      it "2 hours" do
        expect(subject.human_readable_time(7200)).to eq "2 hours"
      end
      it "1 day" do
        expect(subject.human_readable_time(86400)).to eq "1 day"
      end
      it "2 days" do
        expect(subject.human_readable_time(172800)).to eq "2 days"
      end
      it "21 days, 16 hours, 16 minutes, 21 seconds"  do
        expect(subject.human_readable_time(1872981))
          .to eq "21 days, 16 hours, 16 minutes, 21 seconds"
      end
      it "365 days"  do
        expect(subject.human_readable_time(31536000))
          .to eq "365 days"
      end
    end
  end
end
