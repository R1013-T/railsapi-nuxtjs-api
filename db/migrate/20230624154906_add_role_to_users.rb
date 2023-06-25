class AddRoleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :integer, null: false
    add_column :users, :permission, :integer, null: false, default: 0
  end
end