class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  before_action :authenticate_user
  before_action :validate_user


  def authenticate_user
    @current_user = User.find_by_access_token(request.headers['Authorization'])
  end

  def validate_user
    return if @current_user
    render status: 401, json: { response: "Invalid access_token"}
    false
  end

  def current_user
    @current_user
  end

end
