class Users::UserAuthenticator

  def initialize(email, password)
    @user = User.where(email: email).first
    @password = password
  end

  def authenticate
    return false unless @user

    if @user.password == @password
      @user
    else
      false
    end
  end
end