class AddAdminToUser < ActiveRecord::Migration
  def change
    add_column :students, :admin, :boolean, default: false
  end
end
