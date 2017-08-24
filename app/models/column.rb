class Column < ApplicationRecord
  belongs_to :datasheet
  has_many :cells
  validates :name, presence: true
end
