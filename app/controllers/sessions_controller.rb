class SessionsController < ApplicationController

  def create
    user = User.where(email: session_params[:email]).first

    if Users::UserAuthenticator.new(user).authenticate(session_params[:password])
      # Here I can think in a way to or in every login generate a new token, or have some
      # invalidate mechanism to expire the token. For now lets keep it simple
      render status: 200, json: { response: "User logged in successfully",
                                     access_token: user.access_token}
    else
      render status: 401, json: { response: "User credentials are wrong"}
    end
  end

  private

    def session_params
      params.require(:user).permit(:email, :password)
    end

end
