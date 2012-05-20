Rails.application.config.to_prepare do
  Refinery::User.class_eval do
    include Refinery::User::ForemExtension
  end

  Forem::ForumsController.class_eval do
    include Forem::ForumsControllerExtension
  end

  Forem::Forum.class_eval do
    extend FriendlyId
    friendly_id :title
  end

  Forem::Topic.class_eval do
    extend FriendlyId
    friendly_id :subject
  end
end