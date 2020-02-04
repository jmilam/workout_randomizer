class Task < ApplicationRecord
  belongs_to :gym
  has_many :time_cards

  def calculate_time(time_card)
    if duration.nil?
      time_card.end_time.nil? ? 0 : ((time_card.end_time - time_card.start_time) / 60).round
    else
      duration
    end
  end
end
