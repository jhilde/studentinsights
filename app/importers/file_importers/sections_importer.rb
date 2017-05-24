class SectionsImporter < Struct.new :school_scope, :client, :log, :progress_bar

  def remote_file_name
    'rdiclass.csv'
  end

  def data_transformer
    CsvTransformer.new
  end

  def filter
    SchoolFilter.new(school_scope, :school_id)
  end

  def school_ids_dictionary
    @dictionary ||= School.all.map { |school| [school.local_id, school.id] }.to_h
  end

  def import_row(row)
    section = SectionRow.new(row, school_ids_dictionary).build.save!
  end
  
end