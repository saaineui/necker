class Datasheet < ApplicationRecord
  has_many :rows
  has_many :columns
  validates :name, presence: true
end
