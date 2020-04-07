module UsersHelper
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.user_name, class: "gravatar")
  end

  #current user
  # def current_user
  #   if session[:user_id]
  #     User.find_by(id: session[:user_id])
  #   end
  # end


end
