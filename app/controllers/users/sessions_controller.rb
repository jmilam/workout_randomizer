# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    flash[:alert] = nil
    flash[:notice] = nil
    uri = URI.parse(request.original_url)
    @gym = Gym.where("lower(name) = ?", uri.host.split('.').first.to_s.gsub("_", " ")).last
    super
  end

  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(:scope => :user)
    if resource.account_disabled
      sign_out(resource)

      flash[:alert] = "Please contact your gym. Your account has been disabled."
      redirect_to new_user_session_path
    else
      sign_in(:user, resource)
      redirect_to profile_index_path
    end
  end

  # DELETE /resource/sign_out
  def destroy
    sign_out current_user

    redirect_to user_session_path
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
