class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.boolean :admin

      t.timestamps null: false
    end
  end
end
