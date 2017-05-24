class SectionRow < Struct.new(:row, :school_ids_dictionary)
  # Represents a row in a CSV export from Somerville's Aspen X2 student information system.
  # Some of those rows will enter Student Insights, and the data in the CSV will be written into the database
  # (see name_view_attributes, demographic_attributes, school_attribute).
  #
  # Contrast with section.rb, which is represents a student once they've entered the DB.
  #
  # Expects the following headers:
  #
  #   :unique_class_id_section, :school_id, :school_period, :course_id

  def self.build(row)
    new(row).build
  end

  def build
    section = Section.find_or_initialize_by(local_id: row[:unique_class_id_section])
    section.assign_attributes(attributes)
    return section
  end

  private

  def course
    Course.find_by_local_id! row[:course_id]
  end

  def attributes
    {
      school_id: school_rails_id,
      course_id: course.id
    }
  end

  def school_local_id
    row[:school_id]
  end

  def school_rails_id
    school_ids_dictionary[school_local_id] if school_local_id.present?
  end

end
