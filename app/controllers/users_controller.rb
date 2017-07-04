class UsersController < ApplicationController
  skip_before_action :validate_user

  def create
    @user = User.new(user_params)

    if @user.save
      #define a random access-token for the registrated user
      random_access_token = SecureRandom.hex
      @user.update_attributes(access_token: random_access_token)

      render status: 200, json: { user: @user, response: "User was successfully created" }
    else
      render status: 401, json: { errors: @user.errors}
    end

  end


  private
    #Never trust parameters from the scary internet, onlu allow the white list through
    def user_params
      params.require(:user).permit!
    end
end
