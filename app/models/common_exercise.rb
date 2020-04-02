class CommonExercise < ApplicationRecord
  has_many :exercises
  belongs_to :gym
  accepts_nested_attributes_for :exercises
  validates :name, presence: true, uniqueness: true
  has_attached_file :video
  validates_attachment_content_type :video, content_type: /\Avideo\/.*\Z/
end
