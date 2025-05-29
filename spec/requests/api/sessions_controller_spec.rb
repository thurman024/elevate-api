require 'rails_helper'

RSpec.describe Api::SessionsController, type: :request do
  describe 'POST /api/sessions' do
    let(:user) { create(:user, email: 'test@example.com', password: 'password123') }

    context 'with valid credentials' do
      let(:valid_params) { { email: user.email, password: 'password123' } }

      it 'returns a session token' do
        post '/api/sessions', params: valid_params

        expect(response).to have_http_status(:success)
        expect(json_response).to include('token')
        expect(json_response['token']).to eq(user.reload.session_token)
      end
    end

    context 'with invalid password' do
      let(:invalid_params) { { email: user.email, password: 'wrongpassword' } }

      it 'returns an error message' do
        post '/api/sessions', params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include('Invalid email or password')
      end
    end

    context 'with non-existent email' do
      let(:nonexistent_params) { { email: 'nonexistent@example.com', password: 'password123' } }

      it 'returns an error message' do
        post '/api/sessions', params: nonexistent_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']).to include('Invalid email or password')
      end
    end
  end
end
