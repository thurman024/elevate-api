# This service is used to interact with the billing API.

class BillingApiService
  BASE_URL = "https://interviews-accounts.elevateapp.com/api/v1/users"

  def initialize(user_id)
    @user_id = user_id
    @token = ENV["BILLING_API_TOKEN"]
  end

  def fetch_subscription_status
    response = HTTParty.get(
      "#{BASE_URL}/#{@user_id}/billing",
      headers: {
        "Authorization" => "Bearer #{@token}"
      }
    )
    
    handle_response(response)
  end

  private

  def handle_response(response)
    if response.success?
      JSON.parse(response.body)
    else
      # Log the error and return an unavailable response to avoid a 500 error
      Rails.logger.error("Failed to fetch subscription status: #{response.code} - #{response.body}")
      unavailable_response
    end
  end

  def unavailable_response
    { subscription_status: "unavailable" }
  end
end