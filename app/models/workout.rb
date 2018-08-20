class Workout < ApplicationRecord
  include SharedFunctions

  has_many :workout_groups, dependent: :destroy
  has_many :user_previous_workouts, through: :workout_groups, source: 'workout_details'
  has_many :exercises, through: :workout_groups
  has_many :likes

  belongs_to :category
  belongs_to :gym

  validates :name, :frequency, presence: true

  def self.valid_workout_with_workout_groups(user)
    workout = user.gym.workouts.includes(:exercises)
                  .joins(:category)
                  .where(categories: { goal_id: user.goal_id })
                  .sample

    if workout.workout_groups.empty?
      raise 'Not Workout Groups setup for this workout!'
    else
      [workout, workout.workout_groups.sample]
    end
  rescue StandardError
    retry
  end

  def self.remove_nils(workouts)
    workouts.each { |e| e.delete_if(&:nil?) }
  end

  def self.sort_by_likes(user, workouts=nil)
    # Returns workouts by gym sorted by most likes
    if workouts.nil?
      workouts = user.gym.workouts.includes(:exercises)
    end
    workouts.sort_by { |workout| workout.likes.count }
            .reverse
  end

  def created_by
    unless created_by_user_id.nil?
      user = User.find_by(id: created_by_user_id)
      "Created By: #{user.first_name} #{user.last_name}"
    end
  end
end
