class Datasheet < ApplicationRecord
  has_many :rows, dependent: :destroy
  has_many :columns, dependent: :destroy
  validates :name, presence: true
  
  def populated?
    rows.count.positive? && columns.count.positive?
  end
end
