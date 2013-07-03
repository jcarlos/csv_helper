module CSVHelper
  class CSVExporter
    require 'csv'

    def initialize filename, headers, append
      @headers = headers
      if append
        @csv = CSV.open(filename, 'ab')
      else
        @csv = CSV.open(filename, 'wb')
      end
      @csv.puts @headers
      @csv.flush
    end

    def add_row row
      check_for_required_columns row
      line = Array.new
      @headers.each do |header|
        line << row[header]
      end
      @csv.puts line
      @csv.flush
    end

    private
    def check_for_required_columns row
      missing_cols = []
      @headers.each do |col|
        missing_cols << col unless row.include? col
      end
      raise ArgumentError, "Missing required columns: #{missing_cols.join(', ')}" unless missing_cols.empty?
    end
  end
end
