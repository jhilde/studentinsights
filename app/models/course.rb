class Course < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  validates :name, presence: true, uniqueness: { scope: [:name, :school] }
  validates :slug, uniqueness: true, presence: true
  validates :school, presence: true
  has_many :sections
  belongs_to :school
end
