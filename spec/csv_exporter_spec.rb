require 'spec_helper'

# Module containing CSVImporter and CSVExporter
module CSVHelper
  describe CSVExporter do
    let(:csv_mock) { mock('csv_mock') }

    it 'creates a csv in append mode' do
      CSV.should_receive(:open)
        .with('output.csv', 'ab')
        .and_return(csv_mock.as_null_object)
      CSVExporter.new('output.csv', [], true)
    end

    it 'creates a csv in write mode' do
      CSV.should_receive(:open)
        .with('output.csv', 'wb')
        .and_return csv_mock.as_null_object
      CSVExporter.new('output.csv', [], false)
    end

    it 'creates a csv with headers' do
      headers = %w(col1, col2, col3, col4)
      CSV.should_receive(:open).with('output.csv', 'wb').and_return csv_mock
      csv_mock.should_receive(:puts).with(headers)
      csv_mock.should_receive(:flush)
      csv_exporter = CSVExporter.new('output.csv', headers, false)
      csv_mock.should_receive(:puts).with(%w(val1, val2, val3, val4))
      csv_mock.should_receive(:flush)
      csv_exporter.add_row(
        'col1' => 'val1',
        'col2' => 'val2',
        'col3' => 'val3',
        'col4' => 'val4'
      )
    end

    it 'check for required columns in the hash' do
      headers = %w(col1, col2, missing1, col3, missing2)
      CSV.should_receive(:open)
        .with('output.csv', 'wb')
        .and_return(csv_mock.as_null_object)
      csv_exporter = CSVExporter.new('output.csv', headers, false)
      row = {
        'col1' => 'blahblah',
        'col2' => 'blahblah',
        'col3' => 'blahblah',
        'col5' => 'blahblah'
      }
      expect do
        csv_exporter.add_row(row)
      end.to raise_error 'Missing required columns: missing1, missing2'
    end
  end
end
