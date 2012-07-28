Refinery::User.class_eval do
  include Refinery::User::ForemExtension

  validates :first_name, :presence => true
  validates :last_name, :presence => true

  attr_accessible :first_name, :last_name, :approved, :forem_admin

  before_create :automatically_forem_approve

  def automatically_forem_approve
    self.forem_state = 'approved'
  end

  def active_for_authentication?
    super && (approved? || has_role?(:superuser))
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end
end