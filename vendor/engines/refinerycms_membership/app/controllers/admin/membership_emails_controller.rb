module Admin
  class MembershipEmailsController < Admin::BaseController
    crudify :membership_email, 
      :title_attribute => :title,
      :order => "title ASC"
  
    def index
      find_all_membership_emails
      @membership_email_parts = MembershipEmailPart.all   
    end
  
  end
end