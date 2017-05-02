class CreateCourses < ActiveRecord::Migration[4.2]
  def change
    create_table :courses do |t|
      t.string    :name
      t.datetime  :created_at
      t.datetime  :updated_at
      t.integer   :school_id
      t.string    :slug
    end
  end
end