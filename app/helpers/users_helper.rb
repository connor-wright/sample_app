module UsersHelper
  
  #Returns the Gravatar for the given user.
  def gravatar_for(user, size: nil)
    #we store emails as downcase but just in case
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, size: size , alt: user.name, class: "gravatar")
  end
end
