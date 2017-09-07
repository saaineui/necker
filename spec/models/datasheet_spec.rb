require 'rails_helper'

RSpec.describe Datasheet, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:rows) }
  it { is_expected.to have_many(:columns) }
  it { is_expected.to have_many(:cells) }
  it { is_expected.to belong_to(:label) }
  
  fixtures :datasheets, :rows, :columns, :cells
  let(:empty) { Datasheet.create(name: 'String') }
  let(:populated) { datasheets(:donors) }
  let(:name) { columns(:donors_name) }
  
  it '#destroy deletes all associated rows' do
    expect { populated.destroy }.to change{ Row.count }.from(1).to(0)
  end
  
  it '#destroy deletes all associated columns' do
    expect { populated.destroy }.to change{ Column.count }.from(2).to(0)
  end
  
  it '#populated? returns true iff there is 1+ row and 1+ column' do
    expect(populated.populated?).to be(true)
    expect(empty.populated?).to be(false)
  end
  
  it '#tag_columns auto-tags first column as label and first 3 as visible' do
    populated.update(label: nil)
    populated.reload
    expect(populated.label_id).to be(nil)
    expect(populated.columns.map(&:visible)).to eq([false, true])
    
    populated.tag_columns
    populated.reload
    
    expect(populated.label_id).to eq(name.id)
    expect(populated.columns.map(&:visible)).to eq([true, true])
  end
end
