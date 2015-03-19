class CreateCourseRequirements < ActiveRecord::Migration
  def change
    create_table :course_requirements do |t|
      t.integer :course_id
      t.integer :requirement_id

      t.timestamps null: false
    end
  end
end
