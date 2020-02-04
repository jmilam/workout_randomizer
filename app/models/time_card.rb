class TimeCard < ApplicationRecord
  belongs_to :user
  belongs_to :task

  def set_task_specifics(task)
    self.start_time = Time.now.in_time_zone
    self.end_time = Time.now.in_time_zone + task.duration.minutes unless task.duration.nil?

    self
  end
end
