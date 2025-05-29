require 'rails_helper'

RSpec.describe Api::UsersController, type: :request do
  describe 'POST /api/user' do
    let(:valid_params) do
      {
        user: {
          email: 'test@example.com',
          password: 'password123'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post api_user_path, params: valid_params, as: :json
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: {
            email: '',
            password: ''
          }
        }
      end

      it 'returns unprocessable entity status' do
        post api_user_path, params: invalid_params, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('errors')
      end
    end
  end

  describe 'GET /api/user' do
    let(:user) { create(:user, :with_session, email: 'test@example.com', games_played: 5) }

    context 'with valid authentication' do
      before do
        allow_any_instance_of(User).to receive(:subscription_status).and_return('active')
      end

      it 'returns the user details' do
        get api_user_path, headers: { 'Authorization': "Bearer #{user.session_token}" }, as: :json

        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response['user']).to include(
          'id' => user.id,
          'email' => user.email,
          'subscription_status' => 'active'
        )
        expect(json_response['user']['stats']).to include(
          'total_games_played' => 5
        )
      end
    end

    context 'without authentication' do
      it 'returns unauthorized status' do
        get api_user_path, as: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
