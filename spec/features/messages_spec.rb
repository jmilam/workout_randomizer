require 'rails_helper'

RSpec.describe 'Messages', js: true do
  let!(:gym) { create(:gym) }
  let!(:user) { create(:user, gym: gym, trainer: true) }
  let!(:client) { create(:user, gym: gym, trainer_id: user.id) }
  let!(:gym_admin) { create(:gym_admin, gym: gym, user_id: user.id) }
  let!(:inbox) { create(:inbox, user: user) }
  let!(:inbox2) { create(:inbox, user: client) }
  let(:message_group) { create(:message_group, inbox: inbox2) }
  let!(:message) { create(:message, message_group: message_group, user: client, recipient_id: user.id) }

  before do
    page.driver.browser.manage.window.resize_to(1024,768)
    sign_in user
    visit profile_index_path
    click_link 'Messages'
  end

  context 'As a trainer' do
    it 'Sends a message to client' do
      click_on 'New Message'
      
      select client.username, from: 'message_recipient_id'
      fill_in 'Message Subject', with: 'Test Message'
      fill_in 'Message Details', with: 'How is your workouts going?'
      click_on 'Send Message'

      expect(page).to have_content 'Test Message'
    end

    it 'Responds to a message from client' do
      click_on message_group.subject

      expect(all('.speech-bubble-left').count).to eq 1
      expect(all('.speech-bubble-right').count).to eq 0

      click_on 'New Message'
      fill_in 'Message Details', with: 'Response'
      click_on 'Send Message'

      expect(page).to have_content message_group.subject
      expect(all('.speech-bubble-right').count).to eq 1
    end
  end

  context 'As a client' do
    let(:message_group2) { create(:message_group, inbox: inbox) }
    let!(:message2) { create(:message, message_group: message_group2, user: user, recipient_id: client.id) }
    before do
      sign_in client
      visit profile_index_path
      click_link 'Messages'
    end

    it 'Sends a message to trainer' do
      click_on 'New Message'
      fill_in 'Message Subject', with: 'Test Message'
      fill_in 'Message Details', with: 'How is your workouts going?'
      click_on 'Send Message'

      expect(page).to have_content 'Test Message'
    end

    it 'responds to a trainer message' do
      click_on message_group2.subject

      expect(all('.speech-bubble-left').count).to eq 1
      expect(all('.speech-bubble-right').count).to eq 0

      click_on 'New Message'
      fill_in 'Message Details', with: 'Response'
      click_on 'Send Message'

      expect(page).to have_content message_group2.subject
      expect(all('.speech-bubble-right').count).to eq 1
    end
  end

  context 'displays error' do
    before do
      click_on 'New Message'
    end

    it 'is missing all data' do
      click_on 'Send Message'
      expect(page).to have_content 'There was an error when sending your message: Validation failed: Detail can\'t be blank, Recipient can\'t be blank'
    end

    it 'is missing message' do
      select client.username, from: 'message_recipient_id'
      fill_in 'Message Subject', with: 'Test Message'
      click_on 'Send Message'

      expect(page).to have_content 'There was an error when sending your message: Validation failed: Detail can\'t be blank'
    end

    it 'is missing subject' do
      select client.username, from: 'message_recipient_id'
      fill_in 'Message Details', with: 'How is your workouts going?'
      click_on 'Send Message'

      expect(page).to have_content 'There was an error when sending your message: Validation failed: Subject can\'t be blank'
    end

    it 'is missing recipient' do
      fill_in 'Message Subject', with: 'Test Message'
      fill_in 'Message Details', with: 'How is your workouts going?'
      click_on 'Send Message'

      expect(page).to have_content 'There was an error when sending your message: Validation failed: Recipient can\'t be blank'
    end
  end
end