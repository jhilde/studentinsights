class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table "courses", force: true do |t|
      t.string   "name"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "slug"
    end
  end
end

    
