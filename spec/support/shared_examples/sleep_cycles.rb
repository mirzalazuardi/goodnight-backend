RSpec.shared_examples 'new sleep cycle' do |result|
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

RSpec.shared_examples 'finish sleep cyle(wake)' do |row_count, duration_seconds|
  it 'has still a row' do
    expect(subject.count).to eq row_count 
  end
  it 'has start value' do
    expect(subject.first.start).not_to eq nil
  end
  it 'has finish value' do
    expect(subject.first.finish).not_to eq nil
  end
  it 'has duration seconds value' do
    expect(subject.first.duration_seconds).to be == duration_seconds
  end
end
