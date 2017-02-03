require 'Roo'
# must use 'gem install roo' to use this

class Spreadsheet
  def initialize(file_path)
    @xls = Roo::Spreadsheet.open(file_path)
  end

  def each_sheet
    @xls.sheets.each do |sheet|
      @xls.default_sheet = sheet
      yield sheet
    end
  end

  def each_row
    0.upto(@xls.last_row) do |index|
      yield @xls.row(index)
    end
  end

  def each_column
    0.upto(@xls.last_column) do |index|
      yield @xls.column(index)
    end
  end
end