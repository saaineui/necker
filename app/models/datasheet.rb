class Datasheet < ApplicationRecord
  belongs_to :label, class_name: 'Column', optional: true
  has_many :rows, dependent: :destroy
  has_many :columns, dependent: :destroy
  has_many :cells, through: :rows
  
  validates :name, presence: true
  
  def populated?
    rows_count.positive? && columns_count.positive?
  end
  
  def tag_columns
    columns.order(:id).first(3).each do |column|
      update(label: column) if label.nil?
      column.update(visible: true)
    end
  end
end
