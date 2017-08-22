require 'rails_helper'

RSpec.describe Datasheet, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:rows) }
  it { is_expected.to have_many(:columns) }
end
