class CreateSections < ActiveRecord::Migration[4.2]
  def change
    create_table :sections do |t|
      t.string    :name
      t.datetime  :created_at
      t.datetime  :updated_at
      t.integer   :school_id
      t.integer   :course_id
      t.string    :slug
    end
  end
end
