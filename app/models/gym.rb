class Gym < ApplicationRecord
  has_many :users
  has_many :workouts
  has_many :workout_groups, through: :workouts
  has_many :exercises, through: :workouts
  has_many :kiosks

  validates :name, :phone_number, presence: true

  scope :new_gyms, -> (date_range=Date.today.beginning_of_week..Date.today.end_of_week) { where(created_at: date_range)}

  def non_selected_users
    users.map(&:id).delete_if { |user_id| admin_ids.include?(user_id.to_s) }
  end
end
