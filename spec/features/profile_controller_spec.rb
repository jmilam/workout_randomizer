require 'rails_helper'

RSpec.describe 'Profile', js: true do
  let(:workout) { create(:workout) }

  before do
    sign_in user
    visit root_path
  end

  context 'Users first time logging in Profile' do
    let(:user) { create(:user) }

    it 'does not show stats' do
      expect(page).to_not have_content('Exercise Weight Changes')
      expect(page).to_not have_content('weeks remaining')
    end

    it 'selects new workout' do
      click_on 'Suggested Workout'
      save_screenshot('/Users/jmilam/Desktop/test.png')
    end
  end

  context 'Returning Users Profile' do
    let(:user) { create(:user, current_workout: workout.id) }

    before do
      sign_in user
      visit root_path
    end

    it 'shows stats' do
      expect(page).to have_content('Exercise Weight Changes')
      expect(page).to have_content("#{workout.duration} weeks remaining")
    end
  end

  context 'User wants to change workout' do
    before do
      let(:user) { create(:user) }
    end

    it 'removes user from current workout' do
    end
  end
end
