require 'csv'

class DatasheetsController < ApplicationController
  before_action :find_datasheet_or_redirect, only: %i[show]
  
  def index
    @datasheets = Datasheet.all
  end

  def show
    columns = @datasheet.columns.order(:id).map(&:name)
    first = columns.size >= 4 ? 3 : columns.size - 1
    last = columns.size >= 5 ? 4 : columns.size - 1
    
    @collection = @datasheet.rows.sample(10).map do |row| 
      cells = row.cells.order(:id)
      [
        cells[columns.index('State').to_i], 
        cells[first], 
        cells[last]
      ].map(&:text_val) 
    end

    @options = { title: @datasheet.name, columns: columns[first..last], contains_label: true }
  end

  private
  
  # before filters
  def find_datasheet_or_redirect
    if Datasheet.exists?(params[:id])
      @datasheet = Datasheet.find(params[:id])
    else
      redirect_back fallback_location: admin_datasheets_path
    end
  end
end
