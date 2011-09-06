class AuthenticationsController < ApplicationController
  skip_before_filter :authenticate_user!

  # oauth callback
  def create
    # uncomment for debugging
    # return render text: '<pre>' + request.env["omniauth.auth"].to_yaml + '</pre>'

    omniauth = request.env["omniauth.auth"]
    auth = Authentication.where(provider_type: omniauth['provider'], uid: omniauth['uid']).first

    # check for possible orphaned authentication record
    if auth && auth.user.nil?
      auth = auth.destroy && nil
    end

    # NOTE: create a route for new_user_merge_path if you want to handle account merges.  Without account merges enabled,
    # the user will simply be logged out of the previous session and logged in to the requested account.

    # Account merge possibility
    # User is logged in and an authentication exists for oauth request
    if defined?(new_user_merge_path) && auth && current_user && auth.user != current_user
      session[:merging_authentication_id] = auth.id
      redirect_to new_user_merge_path(current_user)

    # Sign-in existing user
    # User already exists for oauth request
    elsif auth
      sign_in_and_redirect(:user, auth.user)

    # Add authentication to user
    # Authentication does not exist, but user is already logged in; add authentication to user
    elsif current_user
      # we have to build auth and save here to allow for new account associations
      current_user.apply_oauth_data(omniauth)
      current_user.save!
      authentications_url

    # New User login
    # No authentication matched oauth request and user is not logged in; create new user from oauth data
    else
      user = User.new
      user.apply_oauth_data(omniauth)
      if user.save
        debugger
        sign_in_and_redirect(:user, user)
      else
        # cache omniauth data to use after user has fixed the registration validation errors; see RegistrationsController#build_resource
        session[:omniauth] = omniauth
        redirect_to new_user_registration_url
      end
    end

  rescue Exception => e
    params['omniauth_data'] = omniauth
    notify_hoptoad(e) if defined?(HoptoadNotifier)
    raise
  end

  protected

  # required for rails >= 3.0.4
  # https://github.com/intridea/omniauth/issues/185
  # mostly needed for OpenID providers
  def handle_unverified_request
    true
  end
end
