class Admin < ApplicationRecord
  # Include basic devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable, :recoverable, :rememberable, and :omniauthable
  devise :database_authenticatable, :trackable, :validatable
end
