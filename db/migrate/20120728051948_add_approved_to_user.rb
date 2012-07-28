class AddApprovedToUser < ActiveRecord::Migration
  def change
    add_column Refinery::User.table_name, :approved, :boolean, :default => false, :null => false
    add_index Refinery::User.table_name, :approved
  end
end
