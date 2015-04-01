class AddDefaultsToColumns < ActiveRecord::Migration
  def up
    change_column :teachers, :admin, :boolean, default: false
    change_column :courses, :selectable, :boolean, default: true
  end

  def down
    change_column :teachers, :admin, :boolean, default: nil
    change_column :courses, :selectable, :boolean, default: nil
  end
end
