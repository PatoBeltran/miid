class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.string :code
      t.boolean :selectable
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
