require 'csv'

class DatasheetsController < ApplicationController
  before_action :find_datasheet_or_redirect, only: %i[show]
  
  def index
    @datasheets = Datasheet.all
  end

  def show
    @collection = @datasheet.rows.map do |row| 
      [row.name] + row.cells.map(&:text_val) 
    end

    columns = @datasheet.columns.map(&:name)
    
    @options = { title: @datasheet.name, columns: columns }
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
