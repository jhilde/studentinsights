class StudentSectionAssignmentRow < Struct.new(:row)
  # Represents a row in a CSV export from Somerville's Aspen X2 student information system.
  # Some of those rows will enter Student Insights, and the data in the CSV will be written into the database
  # (see name_view_attributes, demographic_attributes, school_attribute).
  #
  # Contrast with section.rb, which is represents a student once they've entered the DB.
  #
  # Expects the following headers:
  #
  #   :unique_class_id_section, :lasid, :school_id, :course_id, :school_period_id 

  def self.build(row)
    new(row).build
  end

  def build
    assignment = StudentSectionAssignment.find_or_initialize_by(student: student, section: section)
    return assignment
  end

  private


  def student
    Student.find_by_local_id! row[:lasid]
  end

  def section
    Section.find_by_local_id! row[:unique_class_id_section]
  end

end
