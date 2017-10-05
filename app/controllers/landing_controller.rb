class LandingController < ApplicationController
  def featured
    @charts = { 
      'Voter Participation by State Type' => voter_participation_path,
      'Terms of Interest on News Hompages' => words_path,
      'State Data Scatter' => states_xy_path,
      'Book Ratings Scatter' => books_xy_path
    }
  end
  
  def states_xy
    datasheet = Datasheet.includes(:rows, :columns, :cells).find_by(name: 'Per Capita Carbon Emissions and Racial Diversity by State')
    margin_column = datasheet.columns.find_by(name: 'Clinton-Kaine Margin (% Total State Votes) (2016 General Election)')
    income_column = datasheet.columns.find_by(name: 'Median Income (2015)')
    
    @collection = datasheet.rows.order(:id).map do |row| 
      [
        [
          row.cells.where(column: margin_column).first.text_val.to_d,
          row.cells.where(column: income_column).first.text_val.to_d
        ]
      ]
    end
    
    @options = { 
      title: 'Clinton-Kaine Margin (%) vs. Median Income ($ per year)', 
      series_labels: ['50 U.S. States and District of Columbia'],
      rows: datasheet.label.cells.order(:row_id).pluck(:text_val),
      height: 600,
      width: 900,
      data_formatters: %i[percent currency]
    }
  rescue
    nil
  ensure
    render_scatter
  end
    
  def books_xy
    datasheet = Datasheet.includes(:rows, :columns, :cells).find_by(name: 'Book Ratings: Me vs. Goodreads Average')
    my_ratings = datasheet.columns.find_by(name: 'My Rating')
    avg_ratings = datasheet.columns.find_by(name: 'Average Rating')
    
    @collection = datasheet.rows.order(:id).map do |row| 
      [
        [
          row.cells.where(column: my_ratings).first.text_val.to_d,
          row.cells.where(column: avg_ratings).first.text_val.to_d
        ]
      ]
    end
    
    @options = { 
      title: datasheet.name, 
      rows: datasheet.label.cells.order(:row_id).pluck(:text_val),
      height: 600,
      width: 900
    }
  rescue
    nil
  ensure
    render_scatter
  end

  def voter_participation
    datasheet = Datasheet.find_by(name: 'Per Capita Carbon Emissions and Racial Diversity by State')
    @cutoff = 0.03
    
    margin_column = datasheet.columns.find_by(name: 'Clinton-Kaine Margin (% Total State Votes) (2016 General Election)')
    vep_column = datasheet.columns.find_by(name: 'Voting-Eligible Population (VEP) (2016 General Election)')
    voted_column = datasheet.columns.find_by(name: 'Total Voted (2016 General Election)')
    
    swing_states, other_states = datasheet.rows.partition do |row| 
      row.cells.where(column: margin_column).first.text_val.to_d.abs <= @cutoff
    end
    
    blue_other_states, red_other_states = other_states.partition do |row|
      row.cells.where(column: margin_column).first.text_val.to_d.positive?
    end
    
    @options = { 
       title: 'Voter Participation by State Type', 
       series_labels: ['% of Voting-Eligible Population that Voted in 2016 U.S. General Election'], 
       data_formatters: [:percent], 
       rows: ['Swing States', 'Non-Swing States', 'Non-Swing Blue', 'Non-Swing Red'], 
       bar_width: 100 
    }
    
    @collection = [swing_states, other_states, blue_other_states, red_other_states].map do |group| 
      voted = Cell.where(row: group, column: voted_column).pluck(:text_val).map(&:to_d).reduce(:+)
      vep = Cell.where(row: group, column: vep_column).pluck(:text_val).map(&:to_d).reduce(:+)
    
      [ (voted / vep).round(3) ]
    end
  rescue
    nil
  end
  
  private
  
  def render_scatter
    render 'scatter'
  end
end
