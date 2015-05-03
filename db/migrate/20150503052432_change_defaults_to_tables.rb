class ChangeDefaultsToTables < ActiveRecord::Migration
  def up
    change_column :courses, :selectable, :boolean, default: false
  end

  def down
    change_column :courses, :selectable, :boolean, default: true
  end
end
