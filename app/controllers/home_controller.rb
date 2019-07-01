class HomeController < ApplicationController
	layout 'home'
	skip_before_action :authenticate_user!
	def index
	end

	def blog
	end

  def assessment
    @activity_level = { sedentary: 1.2,
                        lightly_active: 1.375,
                        moderately_active: 1.55,
                        very_active: 1.725,
                        extremely_active: 1.9 }
    @gender = ["Male", "Female"]

    @caloric_expenditure = User.calculate_caloric_expenditure(params.dig(:assessment, :gender).to_s,
      params.dig(:assessment, :activity_level).to_f,
      params.dig(:assessment, :height).to_i,
      params.dig(:assessment, :weight).to_i,
      params.dig(:assessment, :age).to_i)

    @bmi = User.calculate_bmi(params.dig(:assessment, :weight).to_i, params.dig(:assessment, :height).to_i)
    @bmi_status = User.bmi_status(@bmi)
  end
end
