class CreateEducatorSectionAssignments < ActiveRecord::Migration[5.0]
  def change
    create_table :educator_section_assignments do |t|
      t.integer  "educator_id"
      t.integer  "section_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
