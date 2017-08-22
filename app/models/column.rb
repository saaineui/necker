class Column < ApplicationRecord
  belongs_to :datasheet
  validates :name, presence: true
end
