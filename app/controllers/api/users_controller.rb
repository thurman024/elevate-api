module Api
  class UsersController < BaseController
    skip_before_action :validate_session_token, only: :create

    def create
      @user = ::User.new(user_params)
      if @user.save
        head :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def show
      render :show
    end

    private

    def user_params
      params.permit(:email, :password)
    end
  end
end
