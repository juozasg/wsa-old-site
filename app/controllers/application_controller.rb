class ApplicationController < ActionController::Base
  protect_from_forgery

  def forem_user
    if current_refinery_user && current_refinery_user.has_role?(:member)
      current_refinery_user
    end
  end

  helper_method :forem_user
end
