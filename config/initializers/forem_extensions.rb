require 'tidy'
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

  Forem::Post.class_eval do
    before_save do
      if self.text_changed?
        self.text = Tidy.new(:show_body_only => 'true').clean(self.text)
      end
    end
  end
end