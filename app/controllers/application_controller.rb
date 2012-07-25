class ApplicationController < ActionController::Base
  protect_from_forgery

  append_before_filter :authenticate_refinery_user!


  def forem_user
    # if current_refinery_user && current_refinery_user.has_role?(:member)
      # current_refinery_user
    # end
    current_refinery_user
  end

  def after_sign_in_path_for(resource)
    session["refinery_user_return_to"] || '/'
  end

  protected

  # def force_login_user
  #   unless current_refinery_user.try(:has_role?, "Member")
  #     session['refinery_user_return_to'] = request.fullpath
  #     # redirect_to refinery.new_refinery_user_session_path
  #   end
  # end

  helper_method :forem_user
end
