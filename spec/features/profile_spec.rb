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
      expect(page).to have_content "Weight:\n#{user.weight}"
      expect(page).to have_content "Height:"
      expect(page).to have_content "BMI:\n#{user.calculate_bmi}"
      expect(page).to have_content "Current Workout:\n#{workout.name}"
      expect(page).to have_content "Current Gym:\n#{user.gym.name}"
    end

    it 'shows links' do
      expect(page).to have_content 'Workout History'
      expect(page).to have_content 'Manually Enter Workout'
      expect(page).to have_content 'Start Workout'
    end

    context 'edits user' do
      before do
        click_link 'edit_profile'
      end

      it 'profile data successfully' do
        fill_in 'Medical Concerns', with: 'None, healthy as a clam'
        click_on 'Edit User Profile'
        expect(page).to have_content 'User successfully updated'
      end

      it 'measurements data successfully' do
        click_link 'User Measurements'
        fill_in 'Upper Arm', with: '13'
        fill_in 'Left Tricep', with: '3'
        click_on 'Edit User Measurements'
        expect(page).to have_content 'User successfully updated'
      end

      context 'user goals' do
        let!(:goal) { create(:goal, user: user) }

        before do
          click_link 'User Goals'
        end

        it 'creates successfully' do
          fill_in 'Goal Details', with: 'My goal is to get fit.'
          click_on 'Submit Goal'

          expect(page).to have_content 'Goal successfully created!'
        end

        it 'deletes successfully' do
          expect(find('#goal-table tbody').all('tr').length).to eq 1

          page.accept_alert 'Are you suer you want to delete this goal?' do
            click_link 'Delete'
          end

          expect(page).to have_content 'Goal successfully deleted'
        end
      end

      context 'gym admin only links' do
        it 'saves user note successfully' do
          create(:gym_admin, gym: gym, user_id: user.id)

          visit profile_index_path
          click_link 'edit_profile'
          click_link 'User Notes'
          fill_in 'Note about user', with: 'User has shoulder pain'
          click_on 'Add Note'

          expect(page).to have_content 'User note successfully added'
        end
        it 'does not show user note link' do
          expect(page).to have_no_link 'User Notes'
        end
      end
    end
  end

  context 'User wants to change workout' do
    it 'removes user from current workout' do
      click_on 'Change Workout'
      expect(page).to have_content 'Awesome job on the workout. Your next workout is waiting for you.'
    end
  end

  context 'User wants to start' do
    it 'Manual Workout' do
      click_link 'Manually Enter Workout'

      expect(page).to have_content 'Select the date you completed the workout'
    end

    it 'Suggested Workout' do
      click_link 'Start Workout'

      expect(page).to have_content 'There are no Workouts for you!'
    end

    it 'View Workout History' do
      click_link 'Workout History'

      expect(page).to have_content 'Workout Details'
    end
  end
end
