class RegistrationsController < Devise::RegistrationsController
  # Clear out omniauth session data if set during oauth callback
  # See AuthenticationsController#create
  def create
    super
    session[:omniauth] = nil if @user.persisted?
  end

  private

  # Apply cached omniauth data to new user
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_oauth_data(session[:omniauth])
      @user.valid?
    end
  end
end
