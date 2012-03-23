Rails.application.config.to_prepare do
  Refinery::User.class_eval do
    include Refinery::User::ForemExtension
  end

  Forem::ForumsController.class_eval do
    include Forem::ForumsControllerExtension
  end

  Forem::Forum.class_eval do
    extend FriendlyId
    friendly_id :title, :use => :history
  end

  Forem::Topic.class_eval do
    extend FriendlyId
    friendly_id :subject, :use => :history
  end

  module Forem
    module FormattingHelper
      def as_formatted_html(text)
        cleaned = Sanitize.clean(text, Sanitize::Config::RELAXED)

        ("<br/>" + cleaned).html_safe
      end
    end
  end

end