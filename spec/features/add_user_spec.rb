require 'rails_helper'

RSpec.describe 'Users', js: true do
  let!(:gym) { create(:gym) }

  context 'Create User' do
    before do
      visit new_user_registration_path
    end

    context 'Fails Validation' do
      before do
        fill_in 'First name', with: 'Peter'
        fill_in 'Last name', with: 'La Fleur'
        fill_in 'Password', with: 'plafluer'
        fill_in 'Email', with: 'plafluer@gmail.com'
        fill_in 'Phone number', with: '1234567890'

        page.execute_script 'window.scrollBy(0,10000)'
      end

      context 'fails because of missing values' do
        it 'does not have height' do
          fill_in 'Weight', with: '175'
          fill_in 'Username', with: 'plafleur'
          select '1 day week', from: 'Regularity'
          select 'Fat Loss', from: 'Goal'
          select gym.name, from: 'Gym'

          click_on 'Create User'

          expect(page).to have_content('* Height can\'t be blank')
        end

        it 'does not have weight' do
          fill_in 'Height', with: '68'
          fill_in 'Username', with: 'plafleur'
          select '1 day week', from: 'Regularity'
          select 'Fat Loss', from: 'Goal'
          select gym.name, from: 'Gym'

          click_on 'Create User'

          expect(page).to have_content('* Weight can\'t be blank')
        end

        it 'does not have username' do
          fill_in 'Height', with: '68'
          fill_in 'Weight', with: '175'
          select '1 day week', from: 'Regularity'
          select 'Fat Loss', from: 'Goal'
          select gym.name, from: 'Gym'

          click_on 'Create User'

          expect(page).to have_content('* Username can\'t be blank')
        end

        it 'does not have regularity' do
          fill_in 'Height', with: '68'
          fill_in 'Weight', with: '175'
          fill_in 'Username', with: 'plafleur'
          select 'Fat Loss', from: 'Goal'
          select gym.name, from: 'Gym'

          click_on 'Create User'

          expect(page).to have_content('* Regularity_id can\'t be blank')
        end

        it 'does not have goal' do
          fill_in 'Height', with: '68'
          fill_in 'Weight', with: '175'
          fill_in 'Username', with: 'plafleur'
          select '1 day week', from: 'Regularity'
          select gym.name, from: 'Gym'

          click_on 'Create User'

          expect(page).to have_content('* Goal_id can\'t be blank')
        end

        it 'does not have gym' do
          fill_in 'Height (inches)', with: '68'
          fill_in 'Weight', with: '175'
          fill_in 'Username', with: 'plafleur'
          select '1 day week', from: 'Regularity'
          select 'Fat Loss', from: 'Goal'

          click_on 'Create User'

          expect(page).to have_content('* Gym must exist')
        end
      end

      context 'user already exists' do
        let!(:user) { create(:user, gym: gym)}

        before do
          fill_in 'Height', with: '68'
          fill_in 'Weight', with: '175'
          fill_in 'Username', with: 'plafleur'
          select '1 day week', from: 'Regularity'
          select 'Fat Loss', from: 'Goal'
          select gym.name, from: 'Gym'

          click_on 'Create User'
        end

        it 'fails to save' do
          save_screenshot('/Users/jmilam/Desktop/test.png')
          expect(page).to have_content('* Username has already been taken')
        end
      end
    end

    context 'Passes Validation' do
      it 'saves user' do
        fill_in 'First name', with: 'Peter'
        fill_in 'Last name', with: 'La Fleur'
        fill_in 'Height (inches)', with: '68'
        fill_in 'Weight', with: '175'
        fill_in 'Username', with: 'plafleur'
        fill_in 'Password', with: 'plafluer'
        fill_in 'Email', with: 'plafluer@gmail.com'
        fill_in 'Phone number', with: '1234567890'
        select '1 day week', from: 'Regularity'
        select 'Fat Loss', from: 'Goal'

        page.execute_script 'window.scrollBy(0,10000)'

        select gym.name, from: 'Gym'
        click_on 'Create User'

        expect(page).to have_content('Profile#index')
      end
    end
  end
end
