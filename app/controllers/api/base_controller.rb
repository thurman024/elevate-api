module Api
  class BaseController < ApplicationController
    before_action :validate_session_token

    def validate_session_token
      auth_header = request.headers['Authorization']

      if auth_header&.starts_with?('Token ')
        token = auth_header.split(' ').last
        @current_user = User.find_by(session_token: token)
      end

      head :unauthorized unless @current_user
    end
  end
end