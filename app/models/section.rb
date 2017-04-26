class Section < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, presence: true, uniqueness: { scope: [:name, :school] }
  validates :slug, uniqueness: true, presence: true
  has_many :student_section_assignments
  has_many :students, through: :student_section_assignments
  has_many :educators, through: :educator_section_assignments
  belongs_to :course

  def show_mcas?
    #HS Need to figure out this logic
    return true
  end
end
