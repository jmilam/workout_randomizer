class Gym < ApplicationRecord
  has_many :users
  has_many :workouts
  has_many :workout_group_pairings
  has_many :workout_groups, through: :workout_group_pairings
  has_many :exercises, through: :workouts
  has_many :kiosks
  has_many :categories
  has_many :fitness_classes

  validates :name, :phone_number, presence: true
  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "logo.jpg"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

  scope :new_gyms, -> (date_range=Date.today.beginning_of_week..Date.today.end_of_week) { where(created_at: date_range)}

  def non_selected_users
    users.map(&:id).delete_if { |user_id| admin_ids.include?(user_id.to_s) }
  end
end
