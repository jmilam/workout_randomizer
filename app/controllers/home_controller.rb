class HomeController < ApplicationController
	layout 'home'
	skip_before_action :authenticate_user!
	def index
	end

	def blog
	end
end
