require 'rails_helper'

RSpec.describe 'Current Workout', js: true do
  let!(:gym) { create(:gym) }
  let!(:workout) { create(:workout, gym: gym) }
  let!(:exercise) { create(:exercise, workout: workout) }
  let!(:user) { create(:user, gym: gym, current_workout: workout.id) }

  before do
    sign_in user
    visit profile_index_path
  end

  context 'Current Workout Available' do
    it 'completes workout' do
      click_link "Start Workout"

      expect(page).to have_content("Exercises Completed 0 of 1")
      find(".exerciseModalLink").click

      fill_in 'exercises_workout_detail__rep_1_weight', with: 30
      click_button 'Close'
      click_button 'Next Exercise >>'

      expect(page).to have_content('Awesome job today. You have completed all the exercises for todays workout.')
    end

    it 'continues to next exercise' do
      exercise2 = create(:exercise, workout: workout)
      click_link "Start Workout"

      expect(page).to have_content("Exercises Completed 0 of 2")
      find(".exerciseModalLink").click

      fill_in 'exercises_workout_detail__rep_1_weight', with: 30
      click_button 'Close'
      click_button 'Next Exercise >>'

      expect(page).to have_content("Exercises Completed 1 of 2")
    end

    context 'previous data' do
      let!(:user_previous_workout) { create(:user_previous_workout, workout: workout, user: user) }
      let!(:workout_detail) { create(:workout_detail, exercise: exercise, workout_date: user_previous_workout.workout_date)}
      it 'in placeholder for reference' do
        p user
        p user_previous_workout
        p workout_detail
      end
    end
  end
end
