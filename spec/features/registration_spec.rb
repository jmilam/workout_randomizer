require 'rails_helper'

RSpec.describe 'Registration', js: true do
  let!(:gym) { create(:gym) }

  before do 
    visit new_user_registration_path
  end

  it 'successfully registers' do
    fill_in 'First Name', with: 'Test'
    fill_in 'Last Name', with: 'User'
    fill_in 'Email', with: 'test.user@email.com'
    fill_in 'Password', with: 'Te$tuseR1'
    select gym.name, from: 'Gym'
    check 'Not a robot'
    click_on 'Create User'

    expect(page).to have_content 'Please fill out remainder of information and get started working out. Click on image placeholder to complete all user information or click Start Workout to get started now.'
  end

  context 'fails to register user' do
    it 'is missing gym' do
      fill_in 'First Name', with: 'Test'
      fill_in 'Last Name', with: 'User'
      fill_in 'Email', with: 'test.user@email.com'
      fill_in 'Password', with: 'Te$tuseR1'
      check 'Not a robot'
      click_on 'Create User'

      expect(page).to have_content '* Gym must exist'
    end

    
    context 'email' do
      before do
        fill_in 'First Name', with: 'Test'
        fill_in 'Last Name', with: 'User'
        fill_in 'Password', with: 'Te$tuseR1'
        select gym.name, from: 'Gym'
        check 'Not a robot'
      end

      it 'is missing' do
        click_on 'Create User'
        expect(page).to have_content '* Email can\'t be blank'
      end

      it 'is not unique' do
        create(:user, gym: gym, email: 'test.user@email.com')

        fill_in 'Email', with: 'test.user@email.com'
        click_on 'Create User'

        expect(page).to have_content '* Email has already been taken'
      end
    end

    it 'is missing first name' do
      fill_in 'Last Name', with: 'User'
      fill_in 'Email', with: 'test.user@email.com'
      fill_in 'Password', with: 'Te$tuseR1'
      check 'Not a robot'
      click_on 'Create User'

      expect(page).to have_content '* First_name can\'t be blank'
    end

    it 'is missing last name' do
      fill_in 'First Name', with: 'Test'
      fill_in 'Email', with: 'test.user@email.com'
      fill_in 'Password', with: 'Te$tuseR1'
      check 'Not a robot'
      click_on 'Create User'

      expect(page).to have_content '* Last_name can\'t be blank'
    end

    it 'is missing password' do
      fill_in 'First Name', with: 'Test'
      fill_in 'Last Name', with: 'User'
      fill_in 'Email', with: 'test.user@email.com'
      check 'Not a robot'
      click_on 'Create User'

      expect(page).to have_content '* Password can\'t be blank'
    end

    it 'is a robot' do
      fill_in 'First Name', with: 'Test'
      fill_in 'Last Name', with: 'User'
      fill_in 'Email', with: 'test.user@email.com'
      fill_in 'Password', with: 'Te$tuseR1'
      click_on 'Create User'

      expect(page).to have_content 'User cannot be a robot'
    end
  end
end