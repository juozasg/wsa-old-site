require 'forem_html_formatter'

Forem.user_class = "Refinery::User"
Forem.user_profile_links = true
Forem.email_from_address = "admin@members.workersolidarity.org"
Forem.formatter = Forem::Formatters::HTML
Forem.avatar_user_method = "avatar_url" # Method called on user to return an image url for a non-gravatar custom avatar
Forem.per_page = 20
