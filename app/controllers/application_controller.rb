class ApplicationController < ActionController::Base
  protect_from_forgery

  append_before_filter :authenticate_refinery_user!

  before_filter {
    content_for :stylesheets, "<link href='/assets/flash.css' media='screen' rel='stylesheet' type='text/css' />".html_safe
    content_for :javascripts, "<script src='/assets/flash.js' type='text/javascript'></script>".html_safe
  }

  def forem_user
    # if current_refinery_user && current_refinery_user.has_role?(:member)
      # current_refinery_user
    # end
    current_refinery_user
  end

  def after_sign_in_path_for(resource)
    # don't redirect to confirmation tokens.
    if session["refinery_user_return_to"] =~ /confirmation_token/
      '/'
    else
      session["refinery_user_return_to"] || '/'
    end
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
