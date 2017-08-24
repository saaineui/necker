require 'csv'

class Admin::DatasheetsController < ApplicationController
  before_action :authenticate_admin!
  
  def index
    @datasheets = Datasheet.all
  end

  def new
    @datasheet = Datasheet.new
  end

  def show
    @datasheet = Datasheet.find(params[:id])
  end

  def create
    @datasheet = Datasheet.new(datasheet_params)
    if @datasheet.save
      process_file
      flash[:notice] = @datasheet.populated? ? 'Your upload was successful.' : 'Warning: no data was found.'
      redirect_to admin_datasheet_path(@datasheet)
    else
      flash[:alert] = 'Error: Your upload failed.'
      render 'new'
    end
  end

  def destroy
  end

  private

  def datasheet_params
    params.require(:datasheet).permit(:name)
  end

  def process_file(columns = [])
    return false unless params[:datasheet][:file].class.eql?(ActionDispatch::Http::UploadedFile)
    
    columns, csv_rows = split_csv
    
    csv_rows.each_with_index do |csv_row, row_index|
      row = Row.create(name: row_index + 1, datasheet: @datasheet)

      csv_row.each_with_index do |cell_val, column_index|
        Cell.create(text_val: cell_val, row: row, column: columns[column_index])
      end
    end
  rescue 
    puts 'CSV upload process_file failed.'
  end
  
  def split_csv
    csv_array = CSV.parse(params[:datasheet][:file].read)
    [create_columns(csv_array.shift), csv_array]
  end
  
  def create_columns(csv_row)
    csv_row.map.with_index do |column_name| 
      Column.create(name: column_name, datasheet: @datasheet)
    end
  end
end
