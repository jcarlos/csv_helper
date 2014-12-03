require 'spec_helper'

# Module containing CSVImporter and CSVExporter
module CSVHelper
  describe CSVImporter do

    let(:required_headers) do
      %w(
        col_a1
        col_a2
        col_a3
        col_a4
      )
    end

    let(:csv_importer) do
      CSVImporter.new('spec/fixtures/sample_csv.csv', required_headers)
    end

    it '#filename' do
      expect(csv_importer.filename).to eq 'spec/fixtures/sample_csv.csv'
    end

    describe '#encoding' do
      it 'has default encoding' do
        expect(csv_importer.encoding).to eq 'windows-1252:utf-8'
      end

      it 'has a specified encoding' do
        csv_importer = CSVImporter.new(
          'spec/fixtures/sample_csv.csv',
          required_headers,
          'utf8'
        )
        expect(csv_importer.encoding).to eq 'utf8'
      end
    end

    describe '#csv' do
      it 'returns a csv object' do
        expect(csv_importer.csv).to be_a_kind_of CSV
      end

      it 'has 3 lines in the csv file as per fixture file' do
        csv_importer.csv.read
        expect(csv_importer.csv.lineno).to eq 3
      end
    end

    it 'doesnt have missing headers' do
      expect(csv_importer).not_to be_missing_headers
    end

    describe 'missing required headers' do
      let(:csv_importer) do
        required_headers = %w(
          col_a1
          col_a2
          col_missing_1
          col_a3
          col_missing_2
          col_a4
        )
        CSVImporter.new(
          'spec/fixtures/sample_csv.csv',
          required_headers
        )
      end

      it 'missing_headers?' do
        expect(csv_importer).to be_missing_headers
      end

      it 'returns array of missing headers' do
        expect(csv_importer.missing_headers)
          .to eq %w(col_missing_1 col_missing_2)
      end

      it 'has a predefined message for missing_headers' do
        missing_headers_message = 'Header(s) col_missing_1, '\
        'col_missing_2 missing in the CSV file spec/fixtures/sample_csv.csv'
        expect(csv_importer.missing_headers_message)
          .to eq missing_headers_message
      end
    end
  end
end
