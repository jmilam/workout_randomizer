class HomeController < ApplicationController
	layout 'home'
	skip_before_action :authenticate_user!
	def index
	end

  def ad
  end

	def blog
	end

  def assessment
    @activity_level = { sedentary: 1.2,
                        lightly_active: 1.375,
                        moderately_active: 1.55,
                        very_active: 1.725,
                        extremely_active: 1.9 }
    @frequency = ["No Exercise", "1-3 Days A Week", "3-5 days a week",
                  "6-7 days a week", "Physically demanding job, or challenging exercise routine"]
    @gender = ["Male", "Female"]

    @caloric_expenditure = User.calculate_caloric_expenditure(params.dig(:assessment, :gender).to_s,
      params.dig(:assessment, :activity_level).to_f,
      params.dig(:assessment, :height).to_i,
      params.dig(:assessment, :weight).to_i,
      params.dig(:assessment, :age).to_i).to_i

    @weight_loss = @caloric_expenditure - 500
    @lean_muscle_gain_low = (@caloric_expenditure * 1.05).to_i
    @lean_muscle_gain_high = (@caloric_expenditure * 1.1).to_i

    @bmi = User.calculate_bmi(params.dig(:assessment, :weight).to_i, params.dig(:assessment, :height).to_i)
    @bmi_status = User.bmi_status(@bmi)
  end
end
