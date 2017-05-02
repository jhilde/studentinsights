class Section < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, presence: true, uniqueness: { scope: [:name, :course, :school] }
  validates :slug, uniqueness: true, presence: true
  validates :school, presence: true
  has_many :educators, through: :educator_section_assignment
  has_many :students, through: :student_section_assignment
  belongs_to :school
end
