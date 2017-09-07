require 'rails_helper'

RSpec.describe Column, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to belong_to(:datasheet).counter_cache(true) }
  it { is_expected.to have_many(:cells) }

  fixtures :datasheets, :rows, :columns, :cells
  let(:datasheet) { datasheets(:donors) }
  let(:column) { columns(:donors_name) }
  let(:val_column) { columns(:donors_donation) }
  
  it '#destroy deletes all associated cells' do
    expect { column.destroy }.to change{ Cell.count }.from(2).to(1)
  end

  it '#destroy nullifies any associated label references' do
    expect { column.destroy }.to change{ Datasheet.where(id: datasheet.id, label_id: nil).count }.from(0).to(1)
  end

  it '#visible? returns true if visible and not label' do
    column.update(visible: true)
    column.reload
    
    expect(column.visible).to be(true)
    expect(column.visible?).to be(false)
    expect(val_column.visible?).to be(true)
  end
end
