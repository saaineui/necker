class Cell < ApplicationRecord
  belongs_to :row
  belongs_to :column
end
