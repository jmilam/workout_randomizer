require 'rails_helper'

RSpec.describe 'Session', js: true do
  let!(:gym) { create(:gym) }
  let!(:user) { create(:user, gym: gym) }

  before do 
    page.driver.browser.manage.window.resize_to(1024,768)
    visit new_user_session_path
  end

  it 'successfully signs in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log In'

    expect(page).to have_content 'Start Workout'
  end

  context 'shows errors' do
    it 'has incorrect email' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'Bad Password'
      click_on 'Log In'

      expect(page).to have_content 'Invalid Email or password.'
    end

    it 'has incorrect password' do
      fill_in 'Email', with: 'Baduser@me.com'
      fill_in 'Password', with: user.password
      click_on 'Log In'

      expect(page).to have_content 'Invalid Email or password.'
    end

    it 'has a disabled user account' do
      user.update(account_disabled: true)

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log In'

      expect(page).to have_content 'Please contact your gym. Your account has been disabled.'
    end
  end

  it 'successfully signs out' do
    sign_in user
    visit profile_index_path
    click_on 'Sign Out'

    expect(page).to have_content 'User Successfully Signed Out'
  end
end