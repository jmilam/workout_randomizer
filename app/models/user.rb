class User < ApplicationRecord
  belongs_to :gym
  has_many :user_previous_workouts
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :height, :weight, :regularity_id, :goal_id, :username, :gym_id, presence: true
  validates :username, uniqueness: true

  enum regularity: { '1week' => '1 day week',
                     '2week' => '2 day week',
                     '3week' => '3 day week',
                     '4week' => '4 day week',
                     '5week' => '5 day week' }

  enum goal: { '0' => 'Fat Loss',
               '1' => 'Lean Mass Gain',
               '2' => 'Maintain' }

  def calculate_bmi
  	converted_weight = weight * 0.45
    converted_height = height * 0.025
    converted_height = converted_height * converted_height

    (converted_weight / converted_height).to_i
  end

  def bmi_status(bmi)
  	if bmi < 18.5
  		"yellow"
  	elsif bmi > 25
  		"red"
  	else
  		"green"
  	end
  end
end