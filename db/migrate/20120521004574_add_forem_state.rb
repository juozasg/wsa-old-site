class AddForemState < ActiveRecord::Migration

  def change
    add_column :refinery_users, :forem_state, :string, :default => 'pending_review'
  end
end
