class SchoolFilter < Struct.new(:school_local_ids, :school_row_symbol)
  def initialize(*)
    super
    #default to using :school_local_id to locate the school's local ID
    #to support importers that don't set the school row symbol
    self.school_row_symbol ||= :school_local_id
  end
  
  def include?(row)
    school_local_ids.nil? || school_local_ids.include?(row[self.school_row_symbol])
  end
end
