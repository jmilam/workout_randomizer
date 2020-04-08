class Workout < ApplicationRecord
  include SharedFunctions

  has_many :user_previous_workouts#, through: :workout_groups, source: 'workout_details'
  has_many :exercises
  has_many :likes
  has_many :wods

  belongs_to :category
  belongs_to :gym
  has_many :workout_groups, through: :workout_group_pairings
  has_many :workout_details, through: :user_previous_workouts
  validates :name, presence: true

  has_attached_file :video
  validates_attachment_content_type :video, content_type: /\Avideo\/.*\Z/

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

  def self.top_workouts_by_category(workouts)
    workouts.map do |workout|
      workout.group_by(&:category_id).map { |_key, value| value.first }
    end
  end

  def created_by
    unless created_by_user_id.nil?
      user = User.find_by(id: created_by_user_id)
      "Created By: #{user.first_name} #{user.last_name}"
    end
  end

  def user_worked_out_today?
    !user_previous_workouts.where(workout_date: Date.today).empty?
  end
end
