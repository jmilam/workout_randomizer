require 'rails_helper'

RSpec.describe 'Profile', js: true do
  let!(:gym) { create(:gym) }
  let!(:workout) { create(:workout, gym: gym) }
  let!(:user) { create(:user, gym: gym, current_workout: workout.id) }

  before do
    sign_in user
    visit profile_index_path
  end

  context 'Users Profile' do
    it 'shows stats' do
      expect(page).to have_content("Weight: #{user.weight}")
      expect(page).to have_content("Height:")
      expect(page).to have_content("BMI: #{user.calculate_bmi}")
      expect(page).to have_content("Current Workout: #{workout.name}")
      expect(page).to have_content("Current Gym: #{user.gym.name}")
    end

    it 'shows links' do
      expect(page).to have_content('Workout History')
      expect(page).to have_content('Manually Enter Workout')
      expect(page).to have_content('Start Workout')
    end

    it 'edits successful' do
      click_link 'edit_profile'
      fill_in 'Medical Concerns', with: 'None, healthy as a clam'
      click_on 'Edit User Profile'
      expect(page).to have_content('User successfully updated')
    end
  end

  context 'User wants to change workout' do
    it 'removes user from current workout' do
      click_on 'Change Workout'
      expect(page).to have_content('Awesome job on the workout. Your next workout is waiting for you.')
    end
  end

  context 'User wants to' do
    it 'Start Manual Workout' do
      click_link 'Manually Enter Workout'

      expect(page).to have_content('Select the date you completed the workout')
    end

    it 'Start Suggested Workout' do
      click_link 'Start Workout'

      expect(page).to have_content('There are no Workouts for you!')
    end

    it 'View Workout History' do
      click_link 'Workout History'

      expect(page).to have_content('Workout Details')
    end
  end
end
