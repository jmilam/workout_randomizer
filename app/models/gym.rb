class Gym < ApplicationRecord
  has_many :users
  has_many :workouts
  has_many :exercises, through: :workouts
  has_many :kiosks

  validates :name, :phone_number, presence: true

  def non_selected_users
  	users.map(&:id).delete_if { |user_id| admin_ids.include?(user_id.to_s) }
  end
end
