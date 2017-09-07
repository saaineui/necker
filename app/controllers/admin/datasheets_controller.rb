require 'csv'

class Admin::DatasheetsController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_datasheet_or_redirect, only: %i[show destroy]
  
  def index
    @datasheets = Datasheet.all
  end

  def new
    @datasheet = Datasheet.new
  end

  def show; end

  def create
    @datasheet = Datasheet.new(datasheet_params)
    if @datasheet.save
      process_file
      @datasheet.tag_columns
      flash[:notice] = @datasheet.populated? ? 'Your upload was successful.' : 'Warning: no data was found.'
      redirect_to admin_datasheet_path(@datasheet)
    else
      flash[:alert] = 'Error: Your upload failed.'
      render 'new'
    end
  end

  def destroy
    datasheet_name = @datasheet.name
    
    if @datasheet.destroy
      flash[:notice] = datasheet_name + ' has been deleted.'
    else
      flash[:alert] = "Error: #{datasheet_name} could not be deleted."
    end
    redirect_back fallback_location: admin_datasheets_path
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
    [create_columns(csv_array.first), csv_array[1..csv_array.size - 1]]
  end
  
  def create_columns(csv_row)
    csv_row.map.with_index do |column_name| 
      Column.create(name: column_name, datasheet: @datasheet)
    end
  end
  
  # before filters
  def find_datasheet_or_redirect
    if Datasheet.exists?(params[:id])
      @datasheet = Datasheet.includes(:columns, :rows, :cells).find(params[:id])
    else
      redirect_back fallback_location: admin_datasheets_path
    end
  end
end
