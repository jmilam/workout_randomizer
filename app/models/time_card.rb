class TimeCard < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :user_id, :task_id, :start_time, presence: true
  validate :task_require_client
  validate :duration_required_for_manual_entry

  def set_task_specifics(task)
    self.start_time = Time.now.in_time_zone
    self.end_time = Time.now.in_time_zone + task.duration.minutes unless task.duration.nil?

    self
  end

  def task_require_client
    if task.select_client && client_id.nil?
      errors.add(:client, 'must be selected if task requires a client')
    end      
  end

  def duration_required_for_manual_entry
    if manual_entry && start_time == end_time
      errors.add(:manual_entry, 'must have a duration specified')
    end
  end
end
