class User < ApplicationRecord
  belongs_to :gym
  # belongs_to :trainer
  has_many :user_previous_workouts
  has_many :workout_details
  has_one :inbox
  has_many :messages
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :gym_id, :email, presence: true
  validates :password, presence: true, on: :create

  validates :email, uniqueness: true

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "avatar-placeholder.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  enum regularity: { '1week' => '1 day week',
                     '2week' => '2 day week',
                     '3week' => '3 day week',
                     '4week' => '4 day week',
                     '5week' => '5 day week',
                     '6week' => '6 day week' }

  enum goal: { '0' => 'Fat Loss',
               '1' => 'Lean Mass Gain',
               '2' => 'Maintain',
               '3' => 'Other' }

  scope :new_users, -> (date_range=Date.today.beginning_of_week..Date.today.end_of_week) { where(created_at: date_range)}
  scope :trainers, -> { where(trainer: true) }
  def calculate_bmi
    converted_weight = weight * 0.45
    converted_height = height * 0.025
    converted_height *= converted_height

    converted_height.zero? ? 0 : (converted_weight / converted_height).to_i
  end

  def bmi_status(bmi)
    if bmi < 18.5
      'yellow'
    elsif bmi > 25
      'red'
    else
      'green'
    end
  end

  def this_weeks_workouts
    user_previous_workouts.where(workout_date: (Date.today.in_time_zone.beginning_of_week..Date.today.in_time_zone.end_of_week))
                          .pluck(:workout_group_id)
  end

  def username
    "#{first_name} #{last_name}"
  end


  def workout_complete
    update(current_workout: nil, current_workout_group: nil)
  end

  def current_workout_name
    workout = Workout.find_by(id: current_workout)
    workout.nil? ? 'No Current Workout' : workout.name
  end
end
