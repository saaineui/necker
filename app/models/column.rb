class Column < ApplicationRecord
  belongs_to :datasheet
  has_many :cells, dependent: :destroy
  validates :name, presence: true
end
