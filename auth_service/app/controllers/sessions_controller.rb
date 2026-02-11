class SessionsController < ApplicationController
  include Authentication

  def create
    user = User.authenticate_by(params.permit(:email_address, :password))

    unless user
      return render json: { error: "Usuário ou senha inválidos" }, status: :unprocessable_entity
    end

    token = AccessTokenService.new(user_id: user.id, email: user.email_address, token: nil).encode_access_token
    expires_at = AccessTokenService::TOKEN_EXPIRATION.from_now

    render json: {
      token: token,
      expires_at: expires_at
    }, status: :ok
  end

  def verify
    render json: {
      authenticated: true,
      user: {
        id: @current_user.id,
        email: @current_user.email_address
      }
    }, status: :ok
  end
end
