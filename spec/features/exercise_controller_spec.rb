require 'rails_helper'

RSpec.describe 'Exercises', js: true do
  let(:gym) { create(:gym) }
  let(:user) { create(:user, gym: gym) }
  let(:workout) { create(:workout, gym: gym,
                                   category: create(:category),
                                   created_by_user_id: user.id) }
  let!(:workout_group) { create(:workout_group, workout: workout) }

  before do
    sign_in user

    visit profile_index_path
    find('.navbar-toggler').click
    click_on 'Workouts'
    click_on 'Edit'
  end

  context 'Create New Exercise' do
    before do
      click_on "New Exercise for #{workout_group.name}"
    end

    context 'all values are inputed' do
      it 'does save exercise' do
        fill_in 'Name', with: 'Dumbell Curl'
        select '5', from: 'Set Count?'
        fill_in 'Rep Count?', with: '4-8'

        page.execute_script 'window.scrollBy(0,10000)'

        click_on 'New Exercise'
        expect(page).to have_content('Exercise Dumbell Curl was successfully added to your workout.')
      end
    end

    context 'all values are not inputed' do
      it 'does not save exercise' do
        fill_in 'Exercise Description', with: 'ILSJEOFIJE'
        page.execute_script 'window.scrollBy(0,10000)'

        click_on 'New Exercise'
        expect(page).to have_content("Name can\'t be blank")
      end
    end
  end

  context 'Update Existing Exercise' do
    let!(:exercise) { create(:exercise, workout_group: workout_group) }

    before do
      click_on exercise.name
    end

    it 'updates exercise' do
      check 'Warm Up?'
      fill_in 'Warm up details', with: '1 set of 20 reps to get a good pump.'

      click_on 'Edit Exercise'

      expect(page).to have_content("Exercise #{exercise.name} was successfully updated.")
    end
  end
end
