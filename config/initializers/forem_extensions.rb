Rails.application.config.to_prepare do
  Refinery::User.class_eval do
    include User::ForemExtension
  end

  Forem::ForumsController.class_eval do
    include Forem::ForumsControllerExtension
  end
end

module Forem
  module FormattingHelper
    def as_formatted_html(text)
      ("<br/>" + text + "<br/>").html_safe
    end
  end
end


