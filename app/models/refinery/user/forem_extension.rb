module Refinery::User::ForemExtension
  def forem_admin?
    has_role?(:superuser)
  end

  def avatar_url
    "/images/blank.png"
  end
end
