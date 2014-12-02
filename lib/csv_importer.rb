# Module containing CSVImporter and CSVExporter
module CSVHelper
  # Imports a CSV making sure that all required columns are present
  class CSVImporter
    # TODO: rename fields to headers
    # TODO: check for additional rows other than the required ones
    require 'csv'
    attr_reader :filename, :required_fields, :encoding

    def initialize(filename, required_fields,
                   encoding = 'windows-1252:utf-8')
      @filename = filename
      @encoding = encoding
      @required_fields = required_fields
      @missing_fields = nil
    end

    def csv
      @csv ||= CSV.open(
        @filename,
        headers: true,
        encoding: @encoding
      )
    end

    def missing_fields?
      !missing_fields.empty?
    end

    def missing_fields_message
      message = nil
      if missing_fields?
        fields = missing_fields.join(', ')
        message = "Field(s) #{fields}" \
          " missing in the CSV file #{filename}"
      end
      message
    end

    def missing_fields
      # only check first time the method is called (imissing_fields = nil)
      unless @missing_fields
        @missing_fields = []
        csv.read
        required_fields.each do |required|
          @missing_fields << required unless csv.headers.include? required
        end
        csv.rewind
        csv
      end
      @missing_fields
    end
  end
end
