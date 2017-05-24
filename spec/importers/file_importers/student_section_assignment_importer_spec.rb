require 'rails_helper'

RSpec.describe StudentSectionAssignmentImporter do

  describe '#import_row' do

    context 'good data' do
      let(:file) { File.open("#{Rails.root}/spec/fixtures/fake_student_section_assignment.txt") }
      let(:transformer) { CsvTransformer.new }
      let(:csv) { transformer.transform(file) }

      let(:importer) { described_class.new }          # We don't pass in args

      let(:import) {
        csv.each { |row| importer.import_row(row) }   # No school filter here because
      }                                               # we are calling 'import' directly
                                                      # on each row

      context 'existing sections and students' do
          let!(:high_school) { School.create(local_id: 'SHS') }
          let!(:course) { FactoryGirl.create(:course, local_id:'ALGEBRA', school: high_school) }
          let!(:section) { FactoryGirl.create(:section, local_id:'ALGEBRA-001', course:course, school: high_school)}
          let!(:student_a) { FactoryGirl.create(:student, local_id: '20')}
          let!(:student_b) { FactoryGirl.create(:student, local_id: '25')}


          it 'creates new student section assignments' do
            expect { import }.to change { StudentSectionAssignment.count }.by 2
          end

          it 'imports student section assignments correctly' do
            import
            expect(student_a.sections).to include section
            expect(student_b.sections).to include section
          end
          
      end

    end
  end
end