require 'rails_helper'

RSpec.describe CoursesImporter do

  describe '#import_row' do

    context 'good data' do
      let(:file) { File.open("#{Rails.root}/spec/fixtures/fake_courses_export.txt") }
      let(:transformer) { CsvTransformer.new }
      let(:csv) { transformer.transform(file) }

      let(:importer) { described_class.new }          # We don't pass in args

      let(:import) {
        csv.each { |row| importer.import_row(row) }   # No school filter here because
      }                                               # we are calling 'import' directly
                                                      # on each row

      let!(:high_school) { School.create(local_id: 'SHS') }
      let!(:healey) { School.create(local_id: 'HEA') }

      context 'no existing courses in database' do

        it 'imports courses' do
          expect { import }.to change { Course.count }.by 3
        end

        it 'imports courses correctly' do
          import

          first_course = Course.find_by_local_id('CERART1')
          expect(first_course.reload.school).to eq high_school
          expect(first_course.name).to eq 'Ceramic Art'

          second_course = Course.find_by_local_id('ALGEBRA')
          expect(second_course.reload.school).to eq high_school
          expect(second_course.name).to eq 'Algebra'

          third_course = Course.find_by_local_id('ELA')
          expect(third_course.reload.school).to eq healey
          expect(third_course.name).to eq 'English Language Arts'
          
        end

      end

    end

  end

end
