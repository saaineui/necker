require 'rails_helper'

RSpec.describe Word, type: :model do
  let(:date) { Date.new(2017, 1, 1) }
  
  { day: 1, generic: 3, month: 31, quarter: 90, year: 365 }.each do |type, days|
    let(type) { Word.new(word: type, start_date: date, snapshots: days) }
  end
  
  let(:happy_joy) { Word.new(word: 'happy-joy') }
  
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:word) }
  it { is_expected.to validate_presence_of(:match_exp) }
  it { is_expected.to validate_presence_of(:start_date) }
  it { is_expected.to validate_presence_of(:snapshots) }
  it { is_expected.to validate_presence_of(:new_york_times) }
  it { is_expected.to validate_presence_of(:wall_street_journal) }
  it { is_expected.to validate_presence_of(:cnn) }
  it { is_expected.to validate_presence_of(:washington_post) }
  
  it '#pretty_time_period returns humanized time period for start_date and snapshots' do
    expect(day.pretty_time_period).to eq('2017-01-01')
    expect(generic.pretty_time_period).to eq('2017-01-01 - 2017-01-03')
    expect(month.pretty_time_period).to eq('January 2017')
    expect(quarter.pretty_time_period).to eq('Q1 2017')
    expect(year.pretty_time_period).to eq('2017')
  end
  
  it '#name_record sets :name to word (time period)' do
    expect(generic.name).to eq(nil)
  
    generic.name_record
    expect(generic.name).to eq('generic (2017-01-01 - 2017-01-03)')
  end
  
  describe '#match_exp_from_word' do
    context 'when :match_exp is nil' do
      it 'sets :match_exp to smart regexp-ready string' do
        happy_joy.match_exp_from_word
        
        expect(happy_joy.match_exp).to eq('happy\s*-?\s*joy')
      end
    end
    
    context 'when :match_exp is not nil' do
      it 'returns false without action' do
        happy_joy.match_exp = 'custom'
        expect(happy_joy.match_exp).to eq('custom')
        
        happy_joy.match_exp_from_word
        expect(happy_joy.match_exp).to eq('custom')
      end
    end
  end
end
