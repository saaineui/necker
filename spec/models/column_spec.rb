require 'rails_helper'

RSpec.describe Column, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to belong_to(:datasheet) }
  it { is_expected.to have_many(:cells) }
end
