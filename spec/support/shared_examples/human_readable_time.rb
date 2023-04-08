RSpec.shared_examples 'human readable time' do |sec, result|
  it result do
    expect(subject.human_readable_time(sec)).to eq result
  end
end
