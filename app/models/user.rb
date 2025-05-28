class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true

  def reset_session_token!
    update!(session_token: SecureRandom.hex(20))
  end
end
