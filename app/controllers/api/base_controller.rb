module Api
  class BaseController < ApplicationController
    before_action :validate_session_token

    def validate_session_token
      @current_user = User.find_by(session_token: session[:session_token])
      head :unauthorized unless @current_user
    end
  end
end