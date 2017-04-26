class CreateSections < ActiveRecord::Migration[5.0]
  def change
    create_table :sections do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "slug"
      t.integer  "educator_id"
      t.integer  "course_id"
    end
  end
end
