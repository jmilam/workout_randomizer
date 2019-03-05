require 'rails_helper'

RSpec.describe 'Profile', js: true do
  let(:workout) { create(:workout) }
  let(:user) { create(:user, current_workout: workout.id) }

  before do
    sign_in user
    visit profile_index_path
  end

  context 'Users Profile' do
    it 'shows stats' do
      expect(page).to have_content("Weight:")
      expect(page).to have_content("Height:")
      expect(page).to have_content("BMI")
      expect(page).to have_content("Current Workout: #{workout.name}")
      expect(page).to have_content("Current Gym: #{user.gym.name}")
      expect(page).to have_content("#{workout.duration} weeks remaining")
    end

    it 'shows links' do
      expect(page).to have_content('Workout History')
      expect(page).to have_content('Manually Enter Workout')
      expect(page).to have_content('Start Workout')
    end
  end

  context 'User wants to change workout' do
    it 'removes user from current workout' do
    end
  end
end
