# This forces updating schema.rb before seeding.  This is necessary
# to allow `bundle exec rake db:migrate db:seed`, which otherwise would
# not update the schema until all rake tasks are completed, and the seed task
# would fail.
#
# See http://stackoverflow.com/questions/37850322/rails-dbseed-unknown-attribute
ActiveRecord::Base.descendants.each do |klass|
  klass.reset_column_information
end

require "#{Rails.root}/db/seeds/database_constants"


puts "Creating demo schools, homerooms, interventions..."
raise "empty yer db" if School.count > 0 ||
                        Student.count > 0 ||
                        InterventionType.count > 0 ||
                        Assessment.count > 0

# The local demo data setup uses the Somerville database constants
# (eg., the set of `ServiceType`s) for generating local demo data and
# for tests.
puts 'Seeding database constants for Somerville...'

DatabaseConstants.new.seed!
School.seed_somerville_schools

healey = School.find_by_name("Arthur D Healey")
wsns = School.find_by_name("West Somerville Neighborhood")
highschool = School.find_by_name("Somerville High")

puts "Creating demo educators..."
Educator.destroy_all

Educator.create!([{
  email: "demo@example.com",
  full_name: 'Principal, Laura',
  password: "demo-password",
  local_id: '350',
  school: healey,
  admin: true,
  schoolwide_access: true,
  can_view_restricted_notes: true
}, {
  email: "demo-admin@example.com",
  password: "demo-password",
  districtwide_access: true,
  admin: true,
}, {
  email: "fake-fifth-grade@example.com",
  full_name: 'Teacher, Sarah',
  password: "demo-password",
  local_id: '450',
  school: healey,
  admin: false,
  schoolwide_access: false,
}, {
  email: "wsns@example.com",
  full_name: 'Teacher, Mari',
  password: 'demo-password',
  local_id: '550',
  school: wsns,
  admin: false,
  schoolwide_access: false,
}, {
  email: "shsamy@example.com",
  full_name: 'HighSchool, Amy',
  password: 'demo-password',
  local_id: '650',
  school: highschool,
  admin: false,
  schoolwide_access: false,
}, {
  email: "shsben@example.com",
  full_name: 'HighSchool, Ben',
  password: 'demo-password',
  local_id: '750',
  school: highschool,
  admin: false,
  schoolwide_access: false,
}, {
  email: "shsjose@example.com",
  full_name: 'HighSchool, Jose',
  password: 'demo-password',
  local_id: '850',
  school: highschool,
  admin: false,
  schoolwide_access: false,
}])

puts 'Creating homerooms..'

homerooms = [
  Homeroom.create(name: "HEA 300", grade: "3", school: healey),
  Homeroom.create(name: "HEA 400", grade: "4", school: healey),
  Homeroom.create(name: "HEA 500", grade: "5", school: healey),
  Homeroom.create(name: "HEA 501", grade: "5", school: healey),
  Homeroom.create(name: "WSNS 500", grade: "5", school: wsns),
]

ServiceUpload.create([
  { file_name: "ReadingIntervention-2016.csv" },
  { file_name: "ATP-2016.csv" },
  { file_name: "SPELL-2016.csv" },
  { file_name: "SomerSession-2016.csv" },
])

fifth_grade_educator = Educator.find_by_email('fake-fifth-grade@example.com')
wsns_fifth_grade_educator = Educator.find_by_email('wsns@example.com')

Homeroom.find_by_name("HEA 500").update_attribute(:educator, fifth_grade_educator)
Homeroom.find_by_name("WSNS 500").update_attribute(:educator, wsns_fifth_grade_educator)

#homerooms.each do |homeroom|
#  puts "Creating students for homeroom #{homeroom.name}..."
#  school = homeroom.school
#  15.times do
#    FakeStudent.new(school, homeroom)
#  end
#end

puts 'Creating courses..'

course_art = Course.create!(local_id: "ART", school: highschool, name: "Art Course")
course_ela = Course.create!(local_id: "ELA", school: highschool, name: "English Language Arts")
course_algebra = Course.create!(local_id: "ALGEBRA", school: highschool, name: "Algebra")

puts 'Creating sections..'

sections = [
  Section.create(local_id: "ART-A", school: highschool, course: course_art),
  Section.create(local_id: "ART-B", school: highschool, course: course_art),
  Section.create(local_id: "ART-C", school: highschool, course: course_art),
  Section.create(local_id: "ELA-A", school: highschool, course: course_ela),
  Section.create(local_id: "ELA-B", school: highschool, course: course_ela),
  Section.create(local_id: "ELA-C", school: highschool, course: course_ela),
  Section.create(local_id: "ALGEBRA-A", school: highschool, course: course_algebra),
  Section.create(local_id: "ALGEBRA-B", school: highschool, course: course_algebra),
  Section.create(local_id: "ALGEBRA-C", school: highschool, course: course_algebra)
]

puts 'Creating high school students..'

highschool_students = []

5.times do
  highschool_students.push(FakeStudent.new(highschool, nil))
end

puts 'Assigning high school students to sections..'
#Each high school student in 0..9 sections
#Should just requiry since this is a FakeStudent not a real one.

highschool_students.each do |student|
  selected_sections = sections.sample(rand(0..9))

  selected_sections.each do |section|
    StudentSectionAssignment.create(student: student, section: section)
  end
end

puts 'Assigning high scool educators to sections..'
#Each section with 0..3 educators

highschool_educators = [
  Educator.find_by_email('shsamy@example.com'),
  Educator.find_by_email('shsben@example.com'),
  Educator.find_by_email('shsjose@example.com')
]

sections.each do |section|
  selected_educators = educators.sample(rand(0..3))

  selected_educators.each do |educator|
    EducatorSectionAssignment.create(educator: educator, section: section)
  end
end


Student.update_risk_levels
Student.update_student_school_years
Student.update_recent_student_assessments
PrecomputeStudentHashesJob.new(STDOUT).precompute_all!(Time.now)

