class EducatorSectionAssignmentImporter < Struct.new :school_scope, :client, :log, :progress_bar

  attr_accessor :require_delete

  def remote_file_name
    'rdiclassstaff.csv'
  end

  def data_transformer
    CsvTransformer.new
  end

  def filter
    SchoolFilter.new(school_scope, :school_id)
  end

  def import_row(row)
    EducatorSectionAssignmentRow.build(row).save!
  end
  
  def delete_data
    EducatorSectionAssignment.delete_all
  end

end