require 'rails_helper'

RSpec.describe Api::User::GameEventsController, type: :request do
  let(:user) { create(:user, :with_session) }
  let(:authorization_header) { "Bearer #{user.session_token}" }
  let(:game_event_params) do
    {
      "game_event": {
        "game_name":"Brevity",
        "type":"COMPLETED",
        "occurred_at":"2025-01-01T00:00:00.000Z"
      }
    }
  end

  describe 'POST /api/user/game_events' do
    context 'when game event type is COMPLETED' do
      it 'increments the games_played counter' do
        expect {
          post api_user_game_events_path, params: game_event_params, headers: { "Authorization": authorization_header }, as: :json
        }.to change { user.reload.games_played }.by(1)
      end

      it 'returns http success' do
        post api_user_game_events_path, params: game_event_params, headers: { "Authorization": authorization_header }, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when game event type is not COMPLETED' do
      let(:other_game_event_params) do
        {
          game_event: {
            type: 'STARTED'
          }
        }
      end

      it 'does not increment the games_played counter' do
        expect {
          post api_user_game_events_path, params: other_game_event_params, headers: { "Authorization": authorization_header }, as: :json
        }.not_to change { user.reload.games_played }
      end
    end
  end
end
