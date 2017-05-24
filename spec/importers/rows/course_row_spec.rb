require 'rails_helper'

RSpec.describe CourseRow do

  describe '#build' do

    let(:course_row) { described_class.new(row) }
    let(:course) { course_row.build }

  end

end
