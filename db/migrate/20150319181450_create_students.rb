class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :major
      t.integer :graduation_date

      t.timestamps null: false
    end
  end
end
