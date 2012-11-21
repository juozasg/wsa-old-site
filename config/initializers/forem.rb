require 'config/app.rb'

Forem.user_class = "Refinery::User"
Forem.user_profile_links = true
Forem.email_from_address = "'@app_name' <no-reply@#{@app_host}>"
Forem.avatar_user_method = "avatar_url" # Method called on user to return an image url for a non-gravatar custom avatar
