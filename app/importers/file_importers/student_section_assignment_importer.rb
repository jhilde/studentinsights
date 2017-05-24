class StudentSectionAssignmentImporter < Struct.new :school_scope, :client, :log, :progress_bar

  def remote_file_name
    'rdiclassroster.csv'
  end

  def data_transformer
    CsvTransformer.new
  end

  def filter
    SchoolFilter.new(school_scope, :school_id_local)
  end

  def import_row(row)
    StudentSectionAssignmentRow.build(row).save!
  end

  def delete_data
    STDOUT.write("deleting")
    StudentSectionAssignment.delete_all
  end
end