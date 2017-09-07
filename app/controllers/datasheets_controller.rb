require 'csv'

class DatasheetsController < ApplicationController
  before_action :find_datasheet_or_redirect, only: %i[show]
  
  ROWS_PER_PAGE = 6
  
  def index
    @datasheets = Datasheet.all
  end

  def show
    page = params[:p].to_i > 0 ? params[:p].to_i : 1
    label_col = label_column
    visible_cols = visible_columns
    
    @collection = @datasheet.rows[rows_range(page)].map do |row| 
      (row.cells.where(column: label_col) + row.cells.where(column: visible_columns).order(:column_id)).map(&:text_val) 
    end

    @options = { title: @datasheet.name, columns: visible_cols.map(&:name), contains_label: true }
    
    @pages = (1..(@datasheet.rows_count / ROWS_PER_PAGE + 1)).to_a
  end

  private
  
  def rows_range(page)
    ((page - 1) * ROWS_PER_PAGE)..(page * ROWS_PER_PAGE - 1)
  end
  
  def label_column
    @datasheet.label || @datasheet.columns.order(:id).first
  end
  
  def visible_columns
    @datasheet.columns.order(:id).select(&:visible?)
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
