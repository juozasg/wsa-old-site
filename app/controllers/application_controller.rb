class ApplicationController < ActionController::Base
  protect_from_forgery

  append_before_filter :force_login_user


  def forem_user
    if current_refinery_user && current_refinery_user.has_role?(:member)
      current_refinery_user
    end
  end

  protected

  def force_login_user
    logger.info params.inspect
    unless current_refinery_user.try(:has_role?, "Member")
      session['refinery_user_return_to'] = request.fullpath
      redirect_to main_app.new_refinery_user_session_path
    end
  end

  helper_method :forem_user
end
