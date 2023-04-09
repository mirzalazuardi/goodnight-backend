RSpec.shared_examples 'new sleep cycle' do |result|
  it "has #{result} row(s)" do
    expect(Sleep.count).to eq result
  end

  it 'has start value' do
    expect(Sleep.last.start).not_to eq nil
  end
  it 'has no finish' do
    expect(Sleep.last.finish).to eq nil
  end
  it 'has no duration seconds value' do
    expect(Sleep.last.duration_seconds).to eq nil
  end
end

RSpec.shared_examples 'finish sleep cyle(wake)' do |row_count, duration_seconds|
  it 'has still a row' do
    expect(Sleep.count).to eq row_count 
  end
  it 'has start value' do
    expect(Sleep.first.start).not_to eq nil
  end
  it 'has finish value' do
    expect(Sleep.first.finish).not_to eq nil
  end
  it 'has duration seconds value' do
    expect(Sleep.first.duration_seconds).to be == duration_seconds
  end
end
