require 'rails_helper'

RSpec.describe SectionsImporter do

  describe '#import_row' do

    context 'good data' do
      let(:file) { File.open("#{Rails.root}/spec/fixtures/fake_sections_export.txt") }
      let(:transformer) { CsvTransformer.new }
      let(:csv) { transformer.transform(file) }

      let(:importer) { described_class.new }          # We don't pass in args

      let(:import) {
        csv.each { |row| importer.import_row(row) }   # No school filter here because
      }                                               # we are calling 'import' directly
                                                      # on each row

      context 'existing course' do
          
          let!(:high_school) { School.create(local_id: 'SHS') }
          let!(:course) { FactoryGirl.create(:course, local_id:'ALGEBRA') }
          
          it 'creates new sections' do
            expect { import }.to change { Section.count }.by 3
          end
          
          it 'imports sections correctly' do
          import

          first_section = Section.find_by_local_id('ALGEBRA-001')
          expect(first_section.reload.school).to eq high_school
          expect(first_section.course).to eq course

          second_section = Section.find_by_local_id('ALGEBRA-002')
          expect(second_section.reload.school).to eq high_school
          expect(second_section.course).to eq course

          third_section = Section.find_by_local_id('ALGEBRA-111')
          expect(third_section.reload.school).to eq high_school
          expect(third_section.course).to eq course
          
        end
      end

      context 'missing course' do
        it ' '
      end

    end
  end
end