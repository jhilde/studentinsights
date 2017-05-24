class CourseRow < Struct.new(:row, :school_ids_dictionary)
  # Represents a row in a CSV export from Somerville's Aspen X2 student information system.
  # Some of those rows will enter Student Insights, and the data in the CSV will be written into the database
  # (see name_view_attributes, demographic_attributes, school_attribute).
  #
  # Contrast with course.rb, which is represents a student once they've entered the DB.
  #
  # Expects the following headers:
  #
  #   :unique_course_id, :school_id, :course_name

  def self.build(row)
    new(row).build
  end

  def build
    course = Course.find_or_initialize_by(local_id: row[:unique_course_id])
    course.assign_attributes(attributes)
    return course
  end

  private

  def attributes
    {
      name: row[:course_name],
      school_id: school_rails_id
    }
  end

  def school_local_id
    row[:school_id]
  end

  def school_rails_id
    school_ids_dictionary[school_local_id] if school_local_id.present?
  end

end
