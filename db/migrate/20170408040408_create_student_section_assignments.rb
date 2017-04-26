class CreateStudentSectionAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :student_section_assignments do |t|
      t.integer  "student_id"
      t.integer  "section_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
