require 'rails_helper'

RSpec.describe 'Manage Workouts', js: true do
  let!(:gym) { create(:gym) }
  let!(:user) { create(:user, gym: gym) }
  let!(:user2) { create(:user, gym: gym) }
  let!(:workout) { create(:workout, gym: gym, created_by_user_id: user2.id) }
  let!(:workout2) { create(:workout, gym: gym, created_by_user_id: user.id) }
  let!(:exercise) { create(:exercise, workout: workout2)}

  context 'Workout Created' do
    before do
      sign_in user
      visit list_workouts_path
    end

    it 'displays workout' do
      expect(page).to have_content workout.name
      expect(page).to have_content "Created By: #{user2.first_name} #{user2.last_name}"
      expect(page).to have_content "Category: #{workout.category.name}"
      expect(page).to have_link 'View'
    end

    it 'marks it as liked' do
      click_link 'View'
      sleep 3
      expect(page).to have_link 'like_workout_link'

      click_link 'like_workout_link'
      expect(page).to have_content 'You liked this workout.'
      expect(page).to have_no_link 'like_workout_link'
    end
  end

  context 'Edits Workout' do
    let!(:common_exercise) { create(:common_exercise, gym: gym) }
    let!(:common_equipment) { create(:common_equipment) }
     before do
      sign_in user
      visit list_workouts_path
      click_link 'Edit'
    end
    
    it 'info' do
      click_link 'Edit Workout'
      fill_in 'Details', with: Faker::Quote.matz
      click_on 'Update Workout'

      expect(page).to have_content "Workout #{workout2.name} was successfully updated."
    end

    it 'selects workout to use' do
      click_link 'Select Workout'
      expect(page).to have_content "New workout selected and ready to use. Click 'Start Workout' to get started."
    end

    context 'add an exercise' do
      before do
        click_link 'Add Exercise'
      end

      it 'successfully' do
        select common_exercise.name, from: 'Exercise'
        select common_equipment.name, from: 'Equipment'
        click_on 'New Exercise'

        expect(page).to have_content "Exercise #{common_exercise.name} was successfully added to your workout."
      end

      it 'unsucessfully w/ errors' do
        click_on 'New Exercise'
        expect(page).to have_content 'There was an error when updating exercise: Validation failed: Common exercise must exist, Common equipment must exist'
      end
    end

    context 'edit an exercise' do
      before do
        click_link exercise.common_exercise.name
      end

      it 'successfully' do
        fill_in 'Exercise Description', with: Faker::Quote.most_interesting_man_in_the_world
        click_on 'Edit Exercise'

        expect(page).to have_content "Exercise #{exercise.common_exercise.name} was successfully updated."
      end

      context 'disables exercise' do
        it 'deletes' do
          click_link 'Disable Exercise'
          expect(page).to have_content 'Exercise was successfully delete.'
        end

        it 'cant delete because it was used' do
          create(:workout_detail, exercise: exercise)
          click_link 'Disable Exercise'
          expect(page).to have_content 'Exercise cannot be deleted because someone has used it with their workout. It will mess up their history. We have disabled it instead.'
        end
      end
    end
  end
end