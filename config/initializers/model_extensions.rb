Rails.application.config.to_prepare do
  Refinery::User.class_eval do
    include User::ForemExtension
  end
end
