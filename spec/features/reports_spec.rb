require 'rails_helper'

RSpec.describe 'Reports', js: true do
  let!(:gym) { create(:gym) }
  let!(:user) { create(:user, gym: gym, employee: true) }
  let!(:past_gym) { create(:gym, created_at: Date.today.end_of_month - 1.month)}
  let!(:past_user) { create(:user, gym: past_gym, created_at: Date.today - 1.month)}

  before do
    sign_in user
  end

  context 'new users & gyms' do
    before do
      visit admin_portal_new_users_path
    end

    it 'defaults to weekly' do
      expect(page).to have_content "Metrics for this Week:"
    end

    it 'displays users' do
      expect(find('#users tbody').all('tr').count).to eq 1
    end

    it 'displays gyms' do
      expect(find('#gyms tbody').all('tr').count).to eq 1
    end

    it 'displays previous gyms/users' do
      select 'Year', from: 'report_time_frame'
      expect(find('#users tbody').all('tr').count).to eq 2
      expect(find('#gyms tbody').all('tr').count).to eq 2
    end
  end

  context 'time cards' do
    before do
      visit admin_portal_time_cards_path
    end

    it 'defaults page to weekly' do
      expect(find('#report_time_frame').value).to eq 'Current Week'
    end

    it 'has no time created' do 
      expect(page).to have_content 'No time cards have been created for the time frame selected.'
    end

    context 'tasks submitted' do
      let!(:task) { create(:task, gym: gym) }
      let!(:time_card) { create(:time_card, task: task, user: user)}

      before do
        visit admin_portal_time_cards_path
      end

      it 'shows task information' do
        expect(find("#user-#{user.id}-tab").present?).to eq true
        expect(find('#userTabContent table tbody').first('tr').first('th').text).to eq task.name
        expect(find('#userTabContent table tbody').all('tr')[1].all('td').first.text).to eq time_card.start_time.strftime("%m/%d/%y")    
        expect(find('#userTabContent table tbody').all('tr')[1].all('td')[1].text).to eq '0:30'  
        expect(find('#userTabContent table tbody').all('tr').last.all('th')[1].text).to eq 'Total Count: 1'  
        expect(find('#userTabContent table tbody').all('tr').last.all('th')[2].text).to eq "Total Time for #{task.name}: 0 Hours 30 Minutes"
        expect(find('#userTabContent table tfoot').first('tr').all('th')[1].text).to eq 'Total Count: 1'  
        expect(find('#userTabContent table tfoot').first('tr').all('th')[2].text).to eq 'Total Time for all tasks: 0 Hours 30 Minutes'  
      end
    end
  end
end
