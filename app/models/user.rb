class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  def reset_session_token!
    update!(session_token: SecureRandom.hex(20))
  end

  # Subscription status is fetched from the billing API
  # Given this service updates the status every 24 hours, we can cache the status for the desired duration
  def subscription_status
    cache_key = "user_subscription_status/#{id}"
    cached_status = Rails.cache.read(cache_key)
    
    if cached_status.nil? || cached_status == "unavailable"
      status = fetch_fresh_status
      # Only cache if we got a valid status
      Rails.cache.write(cache_key, status, expires_in: 24.hours) if status.present?
      status
    else
      cached_status
    end
  end

  def fetch_fresh_status
    api_response = ::BillingApiService.new(id).fetch_subscription_status    
    api_response["subscription_status"]
  end
end