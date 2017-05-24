class Section < ActiveRecord::Base
  validates :local_id, presence: true, uniqueness: { scope: [:local_id, :course_id, :school_id] }
  validates :school, presence: true
  validates :course, presence: true
  has_many :educator_section_assignment
  has_many :educators, through: :educator_section_assignment
  has_many :student_section_assignments
  has_many :students, through: :student_section_assignments
  belongs_to :school
  belongs_to :course


end


