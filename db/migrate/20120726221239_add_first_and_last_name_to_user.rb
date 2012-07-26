class AddFirstAndLastNameToUser < ActiveRecord::Migration
  def change
    add_column Refinery::User.table_name, :first_name, :string, :null => false
    add_column Refinery::User.table_name, :last_name, :string, :null => false
  end
end
