require 'csv'

class DatasheetsController < ApplicationController
  before_action :find_datasheet_or_redirect, only: %i[show]
  
  ROWS_PER_PAGE = 6
  
  def index
    @datasheets = Datasheet.all
  end

  def show
    columns = @datasheet.columns.order(:id).map(&:name)
    first = columns.size >= 4 ? 3 : columns.size - 1
    last = columns.size >= 5 ? 4 : columns.size - 2
    page = params[:p].to_i > 0 ? params[:p].to_i : 1
    
    @collection = @datasheet.rows[rows_range(page)].map do |row| 
      cells = row.cells.order(:id)
      [
        cells[columns.index('State').to_i], 
        cells[first], 
        cells[last]
      ].map(&:text_val) 
    end

    @options = { title: @datasheet.name, columns: columns[first..last], contains_label: true }
    
    @pages = (1..(@datasheet.rows.count / ROWS_PER_PAGE + 1)).to_a
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
  
  def rows_range(page)
    ((page - 1) * ROWS_PER_PAGE)..(page * ROWS_PER_PAGE - 1)
  end
end
