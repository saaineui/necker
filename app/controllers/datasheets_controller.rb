require 'csv'

class DatasheetsController < ApplicationController
  before_action :find_datasheet_or_redirect, only: %i[show]
  
  def index
    @datasheets = Datasheet.all
  end

  def show
    long_names = ratings = @datasheet.name.include? 'Book'
    @rows_per_page = long_names ? 10 : 13
    page = params[:p].to_i.positive? ? params[:p].to_i : 1
    visible_cols = visible_columns
    max_values = ratings ? [5,5] : max_values(visible_cols)
    
    @collection = @datasheet.rows.order(:id).limit(@rows_per_page).offset(offset(page)).map do |row| 
      row.cells.where(column: visible_cols).order(:column_id).pluck(:text_val) 
    end

    @options = { title: @datasheet.name, series_labels: visible_cols.map(&:name), 
                 rows: rows(page), max_values: max_values, data_formatters: formatters }
    @options = @options.merge(bar_width: 78) if long_names
    
    @pages = (1..(@datasheet.rows_count / @rows_per_page + 1)).to_a
  end

  private
  
  def rows(page)
    return [] unless @datasheet.label
    @datasheet.label.cells.order(:row_id).limit(@rows_per_page).offset(offset(page)).pluck(:text_val)
  end
  
  def max_values(visible_cols)
    visible_cols.map do |column|
      column.cells.pluck(:text_val).map(&:to_d).max
    end
  end
  
  def offset(page)
    (page - 1) * @rows_per_page
  end
  
  def visible_columns
    @datasheet.columns.order(:id).select(&:visible?)
  end
  
  def formatters
    visible_columns.map { |col| col.name.include?('%') ? :percent : :delimiter }
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
