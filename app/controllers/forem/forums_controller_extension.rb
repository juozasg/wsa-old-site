module Forem::ForumsControllerExtension
  extend ActiveSupport::Concern
  included do
    # NOTE: leaving code here for reference later
    # before_filter :authenticate_forem_user
  end
end