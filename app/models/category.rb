class Category < ApplicationRecord
  include SharedFunctions
  has_many :workouts
  belongs_to :gym
  validates :name, presence: true

  enum style_tags: { 1 => { 'background-color' => 'bg-light', 'border' => 'border-light', 'text-color' => 'text-light',
                            'thead-color' => 'bg-light', 'style' => 'color: #D5FFFB;' },
                     2 => { 'background-color' => 'bg-info', 'border' => 'border-info', 'text-color' => 'text-info',
                            'thead-color' => 'bg-info', 'style' => 'color: #D5FFFB;' },
                     3 => { 'background-color' => 'bg-success', 'border' => 'border-success', 'text-color' => 'text-success',
                            'thead-color' => 'bg-success', 'style' => 'color: #D5FFFB;' },
                     4 => { 'background-color' => 'bg-warning', 'border' => 'border-warning', 'text-color' => 'text-warning',
                            'thead-color' => 'bg-warning', 'style' => 'color:#D5FFFB;' },
                     5 => { 'background-color' => 'bg-primary', 'border' => 'border-primary', 'text-color' => 'text-primary',
                            'thead-color' => 'bg-primary', 'style' => 'color: #D5FFFB;' } }
  scope :enabled, -> { where(disabled: false) }
end
