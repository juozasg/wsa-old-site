Rails.application.config.to_prepare do
  Refinery::User.class_eval do
    include User::ForemExtension
  end

  Forem::ForumsController.class_eval do
    include Forem::ForumsControllerExtension
  end

  Forem::Forum.class_eval do
    has_friendly_id :title, :use_slug => true, :approximate_ascii => true
  end

  Forem::Topic.class_eval do
    has_friendly_id :subject, :use_slug => true, :approximate_ascii => true
  end
end

module Forem
  module FormattingHelper
    def as_formatted_html(text)
      cleaned = Sanitize.clean(text, Sanitize::Config::RELAXED)

      ("<br/>" + cleaned).html_safe
    end
  end
end


