Rails.application.config.to_prepare do
  Refinery::User.class_eval do
    include User::ForemExtension
  end

  Forem::ForumsController.class_eval do
    include Forem::ForumsControllerExtension
  end
end
