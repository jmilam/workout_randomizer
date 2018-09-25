class HomeController < ApplicationController
	layout 'home'
	skip_before_action :authenticate_user!
	def index
		p current_user
	end
end
