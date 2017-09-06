class Cell < ApplicationRecord
  belongs_to :row, counter_cache: true
  belongs_to :column
end
