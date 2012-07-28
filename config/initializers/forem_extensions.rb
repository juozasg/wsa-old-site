require 'tidy'
Rails.application.config.to_prepare do
  Forem::ForumsController.class_eval do
    include Forem::ForumsControllerExtension
  end

  ### Tidy HTML Post text ###
  Forem::Post.class_eval do
    before_save do
      if self.text_changed?
        self.text = Tidy.new(:show_body_only => 'true').clean(self.text)
      end
    end
  end
end