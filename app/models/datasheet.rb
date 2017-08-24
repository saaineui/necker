class Datasheet < ApplicationRecord
  has_many :rows
  has_many :columns
  validates :name, presence: true
  
  def populated?
    rows.count.positive? && columns.count.positive?
  end
end
