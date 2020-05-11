class DailyLogFood < ApplicationRecord
  belongs_to :daily_log
  belongs_to :food
end
