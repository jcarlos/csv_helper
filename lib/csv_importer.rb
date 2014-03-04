module CSVHelper
  class CSVImporter
    require 'csv'

    def self.import csv_filename, required_fields
      csv = CSV.open(csv_filename, :headers => true, encoding: "windows-1252:utf-8")
      csv.read
      missing_fields = []
      required_fields.each do |required|
        unless csv.headers.include? required
          missing_fields << required.to_s
        end
      end
      raise "Field(s) #{missing_fields.join(', ')} missing in the CSV file #{csv_filename}" unless missing_fields.empty?
      csv.rewind
      csv
    end
  end
end
