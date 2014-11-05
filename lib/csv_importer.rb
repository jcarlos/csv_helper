# Module containing CSVImporter and CSVExporter
module CSVHelper
  # Imports a CSV making sure that all required columns are present
  class CSVImporter
    require 'csv'

    def self.import(csv_filename, required_fields)
      csv = CSV.open(
        csv_filename,
        headers: true,
        encoding: 'windows-1252:utf-8'
      )
      csv.read
      missing_fields = []
      required_fields.each do |required|
        missing_fields << required.to_s unless csv.headers.include? required
      end
      unless missing_fields.empty?
        fields = missing_fields.join(', ')
        error_message = "Field(s) #{fields}" \
         " missing in the CSV file #{csv_filename}"
        fail ArgumentError, error_message
      end
      csv.rewind
      csv
    end
  end
end
