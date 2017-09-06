require 'rails_helper'

RSpec.describe Column, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to belong_to(:datasheet).counter_cache(true) }
  it { is_expected.to have_many(:cells) }

  fixtures :datasheets, :rows, :columns, :cells
  let(:column) { columns(:donors_name) }
  
  it '#destroy deletes all associated cells' do
    expect { column.destroy }.to change{ Cell.count }.from(2).to(1)
  end
end
