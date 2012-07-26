Rails.application.config.to_prepare do
  Refinery::AdminController.class_eval do

    def hide_from_nonrefinery_user
      redirect_to '/' unless refinery_user?
    end

    before_filter :hide_from_nonrefinery_user
  end
end