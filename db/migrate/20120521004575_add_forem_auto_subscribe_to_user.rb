class AddForemAutoSubscribeToUser < ActiveRecord::Migration

  def change
    add_column :refinery_users, :forem_auto_subscribe, :boolean, :default => false
  end
end