require 'rails_helper'

RSpec.describe Row, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to belong_to(:datasheet).counter_cache(true) }
  it { is_expected.to have_many(:cells) }

  fixtures :datasheets, :rows, :columns, :cells
  let(:row) { rows(:donors_one) }
  
  it '#destroy deletes all associated cells' do
    expect { row.destroy }.to change{ Cell.count }.from(2).to(0)
  end
end
