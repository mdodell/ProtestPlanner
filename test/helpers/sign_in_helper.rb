module SignInHelper
  def sign_in_as(user, password)
    post '/login', params: {user_name: user.user_name, password: password}
  end
end