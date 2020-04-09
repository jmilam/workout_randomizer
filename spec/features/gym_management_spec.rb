require 'rails_helper'

RSpec.describe 'Manage Gym', js: true do
  let!(:gym) { create(:gym) }
  let!(:user) { create(:user, gym: gym) }
  let!(:gym_admin) { create(:gym_admin, gym: gym, user_id: user.id) }
  let!(:category) { create(:category, gym: gym) }
  let!(:common_exercise) { create(:common_exercise, gym: gym) }
  let!(:common_equipment) { create(:common_equipment) }

  before do
    page.driver.browser.manage.window.resize_to(1024,768)
    sign_in user
    visit gym_path(gym)
  end

  context 'Manage workouts' do
    before do
      click_link 'workouts-tab'
      click_link 'New Workout'
      expect(page).to have_content 'Workout Details'
      expect(find('#exercise_table').all('tbody tr').length).to eq(0)
    end

    it 'create new workout' do
      fill_in 'Name', with: 'Test Workout'
      select category.name, from: 'Category'
      fill_in 'Workout Details', with: Faker::TvShows::MichaelScott.quote

      select common_exercise.name, from: 'Exercise'
      select common_equipment.name, from: 'Equipment'
      click_on 'Add Exercise'
      sleep 3

      expect(find('#exercise_table').all('tbody tr').length).to eq(1)

      click_on 'Create Workout'

      expect(page).to have_content 'Workout Test Workout was successfully created. Let\'s add some exercises now.'
    end

    it 'shows errors' do
      click_on 'Create Workout'

      expect(page).to have_content 'There was an error when creating exercise: Validation failed: Category must exist, Name can\'t be blank'
    end
  end
end