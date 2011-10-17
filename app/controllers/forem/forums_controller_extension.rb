module Forem::ForumsControllerExtension
  extend ActiveSupport::Concern
  included do
    before_filter :authenticate_forem_user
  end
end