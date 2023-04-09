require 'rails_helper'

RSpec.describe Sleep, type: :model do
  let(:user) { create :user }

  describe '.clock' do
    before do
      Sleep.clock(user.id)
    end

    context 'sleep start' do
      it_behaves_like "new sleep cycle", 1
    end

    context 'sleep finish' do
      before do
        Timecop.freeze(Time.now + 1.hour)
        Sleep.clock(user.id)
      end
      it_behaves_like 'finish sleep cyle(wake)', 1, 3600

      context 'begin a new sleep cycle(row)' do
        before do
          Timecop.return
          Sleep.clock(user.id)
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
