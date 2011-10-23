Rails.application.config.to_prepare do
  Refinery::SessionsController.class_eval do
    skip_before_filter :force_login_user
  end

  Refinery::PasswordsController.class_eval do
    skip_before_filter :force_login_user
  end

  Refinery::UsersController.class_eval do
    skip_before_filter :force_login_user
  end
end