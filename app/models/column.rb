class Column < ApplicationRecord
  belongs_to :datasheet, counter_cache: true
  has_many :cells, dependent: :destroy
  has_one :labelled_datasheet, class_name: 'Datasheet', foreign_key: :label_id, dependent: :nullify
  
  validates :name, presence: true
  
  def visible?
    visible && labelled_datasheet.nil?
  end
end
