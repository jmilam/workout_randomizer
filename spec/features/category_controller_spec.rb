require 'rails_helper'

RSpec.describe 'Categories', js: true do
	let(:user) { create(:user) }

	context 'Create New Category' do
    before do
    	sign_in user

    	visit root_path
    	find('.navbar-toggler').click
    	click_on 'Categories'

    	click_on 'Add a new Category...'
    end

    context 'Validation' do
    	it 'fails and shows error' do
    		click_button 'Create Category'

    		expect(page).to have_content("Name can't be blank")
    	end

    	it 'passes and saves' do
    		fill_in 'Name', with: "Big Flex"
    		click_button 'Create Category'

    		expect(page).to have_content("Category Big Flex was successfully created.")
    	end
    end
  end

  context 'Edit existing Category' do
  	let!(:category) { create(:category) }

  	before do
  		sign_in user
  		visit category_index_path
  		click_on 'Edit'

  		fill_in 'Name', with: 'hardCORE'
  		save_screenshot('/Users/jmilam/Desktop/test.png')
  		click_button 'Update Category'
  	end

  	context 'updates record' do
  		it 'shows successful message' do
  			expect(page).to have_content("Category hardCORE was successfully updated.")
  		end 
  	end
  end
end
