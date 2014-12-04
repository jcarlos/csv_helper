# Module containing CSVImporter and CSVExporter
module CSVHelper
  # Imports a CSV making sure that all required columns are present
  class CSVImporter
    # TODO: check for additional rows other than the required ones
    require 'csv'
    attr_reader :filename, :required_headers, :encoding

    def initialize(filename, required_headers,
                   encoding = 'windows-1252:utf-8')
      @filename = filename
      @encoding = encoding
      @required_headers = required_headers
      @missing_headers = nil
    end

    def csv
      @csv ||= CSV.open(
        @filename,
        headers: true,
        encoding: @encoding
      )
    end

    def missing_headers
      # only check the first time the method is called (missing_headers = nil),
      # after that return the computed result (missing_headers not nil anymore)
      unless @missing_headers
        @missing_headers = []
        csv.read
        required_headers.each do |required|
          @missing_headers << required unless csv.headers.include? required
        end
        csv.rewind
        csv
      end
      @missing_headers
    end

    def missing_headers?
      !missing_headers.empty?
    end

    def missing_headers_message
      message = nil
      if missing_headers?
        headers = missing_headers.join(', ')
        message = "Header(s) #{headers}" \
          " missing in the CSV file #{filename}"
      end
      message
    end
  end
end
