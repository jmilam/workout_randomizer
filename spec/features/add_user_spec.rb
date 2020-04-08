require 'rails_helper'

RSpec.describe 'Users', js: true do
  let!(:gym) { create(:gym) }

  context 'Create User' do
    before do
      visit new_user_registration_path
    end

    context 'Fails Validation' do
      context 'fails because of missing values' do
        it 'does not have email' do
          fill_in 'Password', with: 'plafluer'
          select gym.name, from: 'Gym'
          click_on 'Create User'

          expect(page).to have_content('* Email can\'t be blank')
        end

        it 'does not have password' do
          fill_in 'Email', with: 'plafluer@gmail.com'
          select gym.name, from: 'Gym'
          click_on 'Create User'

          expect(page).to have_content('* Password can\'t be blank')
        end

        it 'does not have gym' do
          fill_in 'Password', with: 'plafluer'
          fill_in 'Email', with: 'plafluer@gmail.com'
          click_on 'Create User'

          expect(page).to have_content('* Gym must exist')
        end
      end

      context 'user already exists' do
        let!(:user) { create(:user, gym: gym) }

        it 'fails to save' do
          fill_in 'Password', with: user.password
          fill_in 'Email', with: user.email
          select gym.name, from: 'Gym'
          click_on 'Create User'

          expect(page).to have_content('* Email has already been taken')
        end
      end
    end

    context 'Passes Validation' do
      it 'saves user' do
        fill_in 'First Name', with: "Dwight"
        fill_in 'Last Name', with: "Shrute"
        fill_in 'Password', with: 'plafluer'
        fill_in 'Email', with: 'plafluer@gmail.com'
        select gym.name, from: 'Gym'
        check 'Not a robot'
        click_on 'Create User'

        expect(page).to have_content('Please fill out remainder of information and get started working out.')
      end
    end
  end
end
