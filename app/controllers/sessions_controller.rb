class SessionsController < ApplicationController
  skip_before_action :validate_user

  def create
    authenticable = Users::UserAuthenticator.new(session_params[:email], session_params[:password]).authenticate

    if authenticable
      # Here I can think in a way to or in every login generate a new token, or have some
      # invalidate mechanism to expire the token. For now lets keep it simple
      render status: 200, json: { response: "User logged in successfully",
                                  access_token: authenticable.access_token}
    else
      render status: 401, json: { response: "User credentials are wrong"}
    end
  end

  private

    def session_params
      params.require(:user).permit(:email, :password)
    end

end
