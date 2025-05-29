module Api
  class SessionsController < BaseController
    skip_before_action :validate_session_token, only: :create

    def create
      user = ::User.find_by(email: params[:email])
      if user && user.authenticate(params[:password])
        session[:session_token] = user.reset_session_token!
        render json: { token: user.session_token }
      else
        render json: { errors: ["Invalid email or password"] }, status: :unprocessable_entity
      end
    end
  end
end