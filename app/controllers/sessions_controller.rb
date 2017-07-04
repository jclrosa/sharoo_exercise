class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.where(email: session_params[:email]).first

    if Users::UserAuthenticator.new(user).authenticate(session_params[:password])
      render status: 200, json: { response: "User logged in successfully",
                                     access_token: user.access_token}
    else
      render status: 401, json: { response: "User credentials are wrong"}
    end
  end

  private

    def session_params
      params.require(:user).permit!
    end

end
