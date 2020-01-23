class CommonEquipment < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
