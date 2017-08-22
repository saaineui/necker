require 'rails_helper'

RSpec.describe Row, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to belong_to(:datasheet) }
end
