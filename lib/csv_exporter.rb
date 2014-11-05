# Module containing CSVImporter and CSVExporter
module CSVHelper
  # Class to make sure a CSV is exported with the provided required columns
  class CSVExporter
    require 'csv'

    def initialize(filename, headers, append)
      @headers = headers
      if append
        @csv = CSV.open(filename, 'ab')
      else
        @csv = CSV.open(filename, 'wb')
      end
      @csv.puts @headers
      @csv.flush
    end

    def add_row(row)
      check_for_required_columns row
      line = []
      @headers.each do |header|
        line << row[header]
      end
      @csv.puts line
      @csv.flush
    end

    private

    def check_for_required_columns(row)
      missing_cols = []
      @headers.each do |col|
        missing_cols << col unless row.include? col
      end
      cols_are_missing = missing_cols.empty? ? false : true
      error_message = "Missing required columns: #{missing_cols.join(', ')}"
      fail ArgumentError, error_message if cols_are_missing
    end
  end
end
