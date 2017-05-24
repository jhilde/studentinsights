class EducatorSectionAssignmentRow < Struct.new(:row)
  # Represents a row in a CSV export from Somerville's Aspen X2 student information system.
  # Some of those rows will enter Student Insights, and the data in the CSV will be written into the database
  # (see name_view_attributes, demographic_attributes, school_attribute).
  #
  # Contrast with section.rb, which is represents a student once they've entered the DB.
  #
  # Expects the following headers:
  #
  #   :class_id_section, :school_id, :unique_staff_id_num, :course_id, :school_period_id

  def self.build(row)
    new(row).build
  end

  def build
    assignment = EducatorSectionAssignment.find_or_initialize_by(educator: educator, section: section)
    return assignment
  end

  private


  def educator
    Educator.find_by_local_id! row[:unique_staff_id_num]
  end

  def section
    Section.find_by_local_id! row[:class_id_section]
  end

end
