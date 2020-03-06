class Gym < ApplicationRecord
  has_many :users
  has_many :workouts
  has_many :workout_group_pairings
  has_many :workout_groups, through: :workout_group_pairings
  has_many :exercises, through: :workouts
  has_many :kiosks
  has_many :categories
  has_many :fitness_classes
  has_many :tasks
  has_many :gym_admins
  has_many :common_exercises

  validates :name, :phone_number, presence: true
  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" },
                           default_url: "logo.jpg",
                           storage: :cloudinary,
                           path: ':id/:style/:filename'

  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

  scope :new_gyms, -> (date_range=Date.today.beginning_of_week..Date.today.end_of_week) { where(created_at: date_range)}

  def current_user_gym_admin(user)
    !gym_admins.where(user_id: user.id).empty?
  end

  def update_gym_admin(admin, user_id)
    current_admin = gym_admins.where(user_id: user_id, gym_id: id)

    if admin
      gym_admins.create(user_id: user_id, gym_id: id) if current_admin.empty?
    else
      gym_admins.each { |admin| admin.destroy! } if !current_admin.empty?
      GymAdmin.where(gym_id: nil).each { |empty_gym| empty_gym.destroy! }
    end
  end
end
