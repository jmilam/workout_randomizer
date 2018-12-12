require 'rails_helper'

RSpec.describe 'Users', js: true do
  let!(:gym) { create(:gym) }

  context 'Create User' do
    before do
      visit new_user_registration_path
    end

    context 'Fails Validation' do
      before do
        fill_in 'Password', with: 'plafluer'
        fill_in 'Email', with: 'plafluer@gmail.com'

        click_on 'Next'

        fill_in 'First name', with: 'Peter'
        fill_in 'Last name', with: 'La Fleur'
      end

      context 'fails because of missing values' do
        it 'does not have height' do
          fill_in 'Weight', with: '175'

          click_on 'Next'

          select '1 day week', from: 'Regularity'
          select 'Fat Loss', from: 'Goal'
          select gym.name, from: 'Gym'

          click_on 'Create User'

          expect(page).to have_content('* Height can\'t be blank')
        end

        it 'does not have weight' do
          fill_in 'Height', with: '68'

          click_on 'Next'

          select '1 day week', from: 'Regularity'
          select 'Fat Loss', from: 'Goal'
          select gym.name, from: 'Gym'

          click_on 'Create User'

          expect(page).to have_content('* Weight can\'t be blank')
        end

        it 'does not have regularity' do
          fill_in 'Height', with: '68'
          fill_in 'Weight', with: '175'

          click_on 'Next'

          select 'Fat Loss', from: 'Goal'
          select gym.name, from: 'Gym'

          click_on 'Create User'

          expect(page).to have_content('* Regularity_id can\'t be blank')
        end

        it 'does not have goal' do
          fill_in 'Height', with: '68'
          fill_in 'Weight', with: '175'

          click_on 'Next'

          select '1 day week', from: 'Regularity'
          select gym.name, from: 'Gym'

          click_on 'Create User'

          expect(page).to have_content('* Goal_id can\'t be blank')
        end

        it 'does not have gym' do
          fill_in 'Height (inches)', with: '68'
          fill_in 'Weight', with: '175'

          click_on 'Next'

          select '1 day week', from: 'Regularity'
          select 'Fat Loss', from: 'Goal'

          click_on 'Create User'

          expect(page).to have_content('* Gym must exist')
        end
      end

      context 'user already exists' do
        let!(:user) { create(:user, gym: gym) }

        before do
          fill_in 'Height', with: '68'
          fill_in 'Weight', with: '175'

          click_on 'Next'

          select '1 day week', from: 'Regularity'
          select 'Fat Loss', from: 'Goal'
          select gym.name, from: 'Gym'

          click_on 'Create User'
        end

        it 'fails to save' do
          expect(page).to have_content('* Email has already been taken')
        end
      end
    end

    context 'Passes Validation' do
      it 'saves user' do
        fill_in 'Password', with: 'plafluer'
        fill_in 'Email', with: 'plafluer@gmail.com'

        click_on 'Next'

        fill_in 'First name', with: 'Peter'
        fill_in 'Last name', with: 'La Fleur'
        fill_in 'Height (inches)', with: '68'
        fill_in 'Weight', with: '175'

        click_on 'Next'

        select '1 day week', from: 'Regularity'
        select 'Fat Loss', from: 'Goal'
        select gym.name, from: 'Gym'
        click_on 'Create User'

        expect(page).to have_content('My Daily Workout')
      end
    end
  end
end
