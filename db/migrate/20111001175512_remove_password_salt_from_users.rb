class RemovePasswordSaltFromUsers < ActiveRecord::Migration
  def self.up
    remove_column ::Refinery::User.table_name, :password_salt
    # Make the current password invalid :(
    ::Refinery::User.all.each do |u|
      u.update_attribute(:encrypted_password, u.encrypted_password[29..-1])
    end
  end

  def self.down
    add_column ::Refinery::User.table_name, :password_salt, :string
  end
end
