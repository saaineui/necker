require 'rails_helper'

RSpec.describe Datasheet, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:rows) }
  it { is_expected.to have_many(:columns) }
  
  fixtures :datasheets, :rows, :columns, :cells
  let(:empty) { Datasheet.new(name: 'String') }
  let(:populated) { datasheets(:donors) }
  
  it '#destroy deletes all associated rows' do
    expect { populated.destroy }.to change{ Row.count }.from(1).to(0)
  end
  
  it '#destroy deletes all associated columns' do
    expect { populated.destroy }.to change{ Column.count }.from(2).to(0)
  end
  
  it '#populated? returns true iff there is 1+ row and 1+ column' do
    expect(empty.populated?).to be(false)
    expect(populated.populated?).to be(true)
  end
end
