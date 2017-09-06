class Row < ApplicationRecord
  belongs_to :datasheet, counter_cache: true
  has_many :cells, dependent: :destroy
  validates :name, presence: true
end
