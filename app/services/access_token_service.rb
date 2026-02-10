require "jwt"

class AccessTokenService
  SECRET_KEY = Rails.application.secret_key_base

  TOKEN_EXPIRATION = 24.hours

  def initialize(user_id:, email: , token:)
    @uset_id = user_id
    @email = email
    @token = token
  end

  def encode_access_token
    payload = {
      user_id: @uset_id,
      email: @email,
      type: "access",
      exp: TOKEN_EXPIRATION.from_now.to_i,
      iat: Time.now.to_i
    }

    JWT.encode(payload, SECRET_KEY)
  end

  def decode_access_token
    decoded = JWT.decode(@token, SECRET_KEY).first
    return nil unless decoded
    return nil unless decoded['type'] == "access"

    decoded
  end

  def access_token_expired?
    decoded = decode_access_token
    return true if decoded.nil?

    Time.at(decoded['exp']) < Time.now
  end
end
