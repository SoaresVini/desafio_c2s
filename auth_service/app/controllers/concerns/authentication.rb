module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication, only: [ :verify ]
  end

  private

  def require_authentication
    token = extract_token_from_header
    return render_unauthorized unless token

    service = AccessTokenService.new(user_id: nil, email: nil, token: token)

    payload = service.decode_access_token
    return render_unauthorized unless payload

    @current_user = User.find_by(id: payload["user_id"])
    return render_unauthorized unless @current_user

    expired = service.access_token_expired?

    render_unauthorized if expired
  end

  def extract_token_from_header
    header = request.headers["Authorization"]
    header&.split(" ")&.last
  end

  def render_unauthorized
    render json: { error: "Não autorizado", authenticated: false }, status: :unauthorized
  end
end
