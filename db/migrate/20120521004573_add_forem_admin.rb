class AddForemAdmin < ActiveRecord::Migration

  def change
    add_column :refinery_users, :forem_admin, :boolean, :default => false
  end
end
