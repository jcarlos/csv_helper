require 'spec_helper'

module CSVHelper
  describe CSVImporter do
    before(:each) do
      csv_importer = CSVImporter.new
    end

    it "returns a csv object after importing a csv file" do
      headers_required = ["col_a1", "col_a2", "col_a3", "col_a4"]
      csv = CSVImporter.import("spec/fixtures/sample_csv.csv", headers_required)
      csv.read
      csv.lineno.should eq 3
    end

    it "complains about required rows missing" do
      headers_required = ["col_a1", "col_a2", "col_missing_1", "col_a3", "col_missing_2", "col_a4"]
      expect { CSVImporter.import "spec/fixtures/sample_csv.csv", headers_required }.to raise_error "Column(s) col_missing_1, col_missing_2 missing in the CSV file spec/fixtures/sample_csv.csv"
    end

    it "doesn't complain if the csv file contains additional rows not required"

  end
end
