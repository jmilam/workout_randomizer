require 'rails_helper'

RSpec.describe 'Manage Gym', js: true do
  let!(:gym) { create(:gym) }
  let!(:user) { create(:user, gym: gym) }
  let!(:disabled_user) { create(:user, gym: gym, account_disabled: true) }
  let!(:gym_admin) { create(:gym_admin, gym: gym, user_id: user.id) }
  let!(:category) { create(:category, gym: gym) }
  let!(:enabled_category) { create(:category, created_by_user_id: user.id, gym: gym) }
  let!(:disabled_category) { create(:category, created_by_user_id: user.id, gym: gym, disabled: true) }
  let!(:common_exercise) { create(:common_exercise, gym: gym) }
  let!(:common_equipment) { create(:common_equipment) }
  let!(:workout) { create(:workout, gym: gym, created_by_user_id: user.id) }
  let!(:workout_group) { create(:workout_group) }
  let!(:workout_group_pairing) { (create(:workout_group_pairing, workout_group: workout_group, workout: workout, gym: gym))}

  before do
    page.driver.browser.manage.window.resize_to(1024,768)
    sign_in user
    visit gym_path(gym)
  end

  context 'Manage Gym' do
    it 'displays information' do
      expect(find('#gym_name').value).to eq gym.name
      expect(find('#gym_phone_number').value).to eq gym.phone_number
      expect(find('#gym_address').value).to eq gym.address
      expect(find('#gym_city').value).to eq gym.city
      expect(find('#gym_state').value).to eq gym.state
      expect(find('#gym_zipcode').value).to eq gym.zipcode
    end

    it 'updates information' do
      fill_in 'Name', with: Faker::Company.name
      click_on 'Update Gym Info'

      expect(page).to have_content 'Successfully Updated Gym Information.'
    end
  end

  context 'Manage Gym Users' do
    before do
      click_link 'gym-users-tab'
    end

    it 'Creates New User' do
      click_on 'New User'

      fill_in 'First Name', with: 'Test'
      fill_in 'Last Name', with: 'User'
      fill_in 'Height', with: '68'
      fill_in 'Weight', with: '200'

      click_link 'Goals >>'
      # Goals select boxes set by default, no need to test select
      click_link 'Measurements >>'
      fill_in 'Upper Arm', with: 15
      fill_in 'Inside Calf', with: 20

      click_link 'Finalize >>'
      fill_in 'Email', with: 'testuser@email.com'
      fill_in 'Pin', with: '123456'
      fill_in 'Phone Number', with: '1234567890'

      click_on 'Join User'
      expect(page).to have_content 'New User, Test User, successfully created.'
    end

    it 'Edits Current User' do
      click_link "#{user.first_name} #{user.last_name}"

      fill_in 'First name', with: "Hakeem"
      click_on 'Edit User Profile'

      expect(page).to have_content 'User successfully updated'
    end

    it 'Disables Users' do
      click_link 'Disable Account'
      expect(page).to have_content "#{user.username} was disabled."
    end

    it 'Enables Users' do
      click_link 'Enable Account'
      save_screenshot
      expect(page).to have_content "#{disabled_user.username} was enabled."
    end
  end

  context 'Manage Popup Workouts' do
    it 'Creates successfully' do
      click_link 'popup-workout-tab'
      click_on 'Setup a Pop Up Workout'

      select workout.name, from: 'wod_workout_id'
      fill_in 'wod_workout_date', with: Date.today

      click_on 'Create Wod'

      expect(page).to have_content 'Your Popup Workout is ready to go!'

      click_link 'popup-workout-tab'
      expect(find('#popup-workout table tbody').all('tr').length).to eq 1
    end
  end

  context 'Manage Categories' do
    before do
      click_link 'categories-tab'
    end

    context 'Create new' do
      before do
        click_link 'nav-new-category-tab'
      end

      it 'successfully' do
        fill_in 'Name', with: 'At Home Workouts'

        click_on 'Create Category'
        expect(page).to have_content "Category At Home Workouts was successfully created."
      end

      it 'shows errors on create' do
        click_on 'Create Category'
        expect(page).to have_content 'There was an error when updating your category: Validation failed: Name can\'t be blank'
      end
    end

    it 'Edits successfully' do
      click_on enabled_category.name
      fill_in 'Name', with: "#{enabled_category.name}-edit"

      click_on 'Update Category'
      expect(page).to have_content "Category #{enabled_category.name}-edit was successfully updated."
    end

    it 'Disabled' do
      click_link 'Disable'
      expect(page).to have_content 'Category was disabled successfully.'
    end

    it 'Enabled' do
      click_link 'Enable'
      expect(page).to have_content 'Category was enabled successfully.'
    end
  end

  context 'Manage Common Exercises' do
    before do
      click_link 'common-exercises-tab'
    end

    context 'Creates' do
      it 'successfully' do
        fill_in 'common_exercises_name', with: 'Push up'
        click_on 'Save'
        expect(page).to have_content 'Exercise Push up was successfully created.'
      end

      it 'unsuccessfully w/ errors' do
        click_on 'Save'
        expect(page).to have_content 'There was an error when creating your exercise'
      end
    end

    context 'Updates' do
      it 'successfully' do
        click_link common_exercise.name
        fill_in 'Common Exercise Name', with: "#{common_exercise.name}-edit"
        click_on 'Update Exercise Info'

        expect(page).to have_content "Exercise #{common_exercise.name}-edit was successfully updated."
      end

      it 'unsuccessfully w/ errors' do
      end
    end
  end

  context 'Manage workouts' do
    before do
      click_link 'workouts-tab'
    end

    context 'New Workout' do
      before do
        click_link 'New Workout'
        expect(page).to have_content 'Workout Details'
        expect(find('#exercise_table').all('tbody tr').length).to eq(0)
      end

      it 'create successfully' do
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

    it 'Edit Workout' do
      click_link 'Edit'
      expect(page).to have_current_path(edit_workout_path(workout.id))
    end
  end

  context 'Manage Workout Groups' do
    before do
      click_link 'workout-groups-tab'
    end

    it 'displays created workout groups' do
    end

    it 'creates new workout group' do
      click_on 'New Workout Group'
      expect(page).to have_content 'Daily Workout'

      # Select boxes for workout and day auto populate, no need to set them here
      click_on 'Add Workout'

      expect(find('#workout_table table tbody').all('tr').count).to eq 1

      fill_in 'Name', with: 'First Workout Group'
      click_on 'Create Workout Group'

      expect(page).to have_content 'Workout Group First Workout Group was successfully created.'
    end

    it 'displays selected workout groups' do
      user.update(current_workout_group: workout_group.id)
      click_link 'View'

      expect(page).to have_content workout_group.name
      expect(find('#workout_table table tbody').all('tr').count).to eq workout_group.workout_group_pairings.count
      expect(find('#workout-group-users-table tbody').all('tr').count).to eq 1
    end

    it 'deletes successfully' do
      click_link 'Delete'
      expect(page).to have_content 'Workout Group was successfully deleted.'
    end
  end

  context 'Manage Tasks' do
  end
end