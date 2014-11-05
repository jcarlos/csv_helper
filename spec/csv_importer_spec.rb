require 'spec_helper'

# Module containing CSVImporter and CSVExporter
module CSVHelper
  describe CSVImporter do

    describe 'returns a csv object after importing a csv file' do
      let(:csv) do
        headers_required = %w(
          'col_a1',
          'col_a2',
          'col_a3',
          'col_a4'
        )
        CSVImporter.import('spec/fixtures/sample_csv.csv', headers_required)
      end

      it 'returns a csv object' do
        csv.should be_a_kind_of CSV
      end

      it 'has 3 lines in the csv file as per fixture file' do
        csv.read
        csv.lineno.should eq 3
      end
    end

    it 'complains about required rows missing' do
      headers_required = %w(
        col_a1,
        col_a2,
        col_missing_1,
        col_a3,
        col_missing_2,
        col_a4
      )
      error_message = 'Field(s) col_missing_1, col_missing_2 missing in the' \
        'CSV file spec/fixtures/sample_csv.csv'
      expect do
        CSVImporter.import 'spec/fixtures/sample_csv.csv', headers_required
      end.to raise_error RuntimeError, error_message
    end

    it 'csv file can have additional rows other than the required' do
      headers_required = %w(col_a1, col_a4)
      CSVImporter.import('spec/fixtures/sample_csv.csv', headers_required)
    end

  end
end
