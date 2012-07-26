Refinery::User.class_eval do
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  attr_accessible :first_name, :last_name

  before_create :automatically_forem_approve

  def automatically_forem_approve
    self.forem_state = 'approved'
  end
end