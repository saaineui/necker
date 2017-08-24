require 'rails_helper'

RSpec.describe Datasheet, type: :model do
  fixtures :datasheets, :rows, :columns
  
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:rows) }
  it { is_expected.to have_many(:columns) }
  
  let(:empty) { Datasheet.new(name: 'String') }
  let(:populated) { datasheets(:donors) }
  
  context 'when uploading a csv' do
    it '#populated? returns true iff there is 1+ row and 1+ column' do
      expect(empty.populated?).to be(false)
      expect(populated.populated?).to be(true)
    end
  end
end
