require 'rails_helper'

RSpec.describe 'Nav Functions', js: true do
  let!(:gym) { create(:gym) }
  let!(:admin) { create(:user, gym: gym) }
  let!(:gym_admin) { create(:gym_admin, gym: gym, user_id: admin.id) }

  before do
    page.driver.browser.manage.window.resize_to(1024,768)
  end

  context 'Gym Admin' do
    before do
      sign_in admin
      visit profile_index_path
    end

    it 'has all nav links' do
      expect(page).to have_link 'Profile'
      expect(page).to have_link 'Workouts'
      expect(page).to have_link 'Messages'
      expect(page).to have_link 'Gym'
      expect(page).to have_link 'Reporting'
      expect(page).to have_link 'Sign Out'
    end
  end

  context 'Gym User' do
    let!(:user) { create(:user, gym: gym) }

    before do
      sign_in user
      visit profile_index_path
    end

    it 'has all non gym admin nav links' do
      expect(page).to have_link 'Profile'
      expect(page).to have_link 'Workouts'
      expect(page).to have_link 'Messages'
      expect(page).to have_no_link 'Gym'
      expect(page).to have_no_link 'Reporting'
      expect(page).to have_link 'Sign Out'
    end
  end

  context 'Nav routes correctly' do
    before do
      sign_in admin
      visit profile_index_path
    end

    it 'to profile' do
      click_link 'Profile'
      expect(page).to have_current_path(profile_index_path)
    end

    it 'to workouts' do
      click_link 'Workouts'
      expect(page).to have_current_path(list_workouts_path)
    end

    it 'to messages' do
      click_link 'Messages'
      expect(page).to have_current_path(inbox_index_path)
    end

    it 'to gym' do
      click_link 'Gym'
      expect(page).to have_current_path(gym_path(gym.id))
    end

    context 'to reporting' do
      before do
        click_link 'Reporting'
      end

      it 'selects new users' do
        click_link 'New Users'
        expect(page).to have_current_path(admin_portal_new_users_path)
      end

      it 'selects time cards' do
        click_link 'Time Card'
        expect(page).to have_current_path(admin_portal_time_cards_path)
      end
    end

    it 'to sign out' do
      click_link 'Sign Out'
      expect(page).to have_current_path(new_user_session_path)
    end
  end
end