require 'rails_helper'

RSpec.describe Cell, type: :model do
  it { is_expected.to belong_to(:row).counter_cache(true) }
  it { is_expected.to belong_to(:column) }
end
