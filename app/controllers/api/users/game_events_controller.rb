# POST /api/users/game_events
#
# This endpoint is used to track game events for a user.
# Logic could be extracted to a service class if more complex
module Api
  module Users
    class GameEventsController < ApplicationController
      def create
        if params.dig(:game_event, :type) == "COMPLETED"
          @current_user.increment!(:games_played)
        end

        head :ok
      end
    end
  end
end