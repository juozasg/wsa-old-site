module User::ForemExtension
  def forem_admin?
    has_role?(:superuser)
  end
end
