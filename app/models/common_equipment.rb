class CommonEquipment < ApplicationRecord
  has_many :exercises
  validates :name, presence: true
end
