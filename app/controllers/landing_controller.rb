class LandingController < ApplicationController
  def featured
    @charts = { 
      'Voter Participation by State Type' => voter_participation_path,
      'Terms of Interest on News Hompages' => words_path,
      'State Data Scatter' => states_xy_path,
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
    
      [(voted / vep).round(3)]
    end
  rescue
    nil
  end
  
  def active_charts
    data = [
      ['Q1 2011', 2.04, 31.87],
      ['Q2 2011', 1.93, 26.82],
      ['Q3 2011', 0.58, 23.79],
      ['Q4 2011', 1.02, 26.70],
      ['Q1 2012', 0.99, 19.38],
      ['Q2 2012', 0.05, -13.26],
      ['Q3 2012', -1.98, -4.68],
      ['Q4 2012', 0.46, 4.04],
      ['Q1 2013', 0.51, 15.02],
      ['Q2 2013', -0.04, 18.37],
      ['Q3 2013', -0.24, 21.08],
      ['Q4 2013', 0.94, 20.22],
      ['Q1 2014', 0.55, 25.66],
      ['Q2 2014', -0.65, 27.18],
      ['Q3 2014', -2.12, 25.16],
      ['Q4 2014', 0.73, 18.20],
      ['Q1 2015', -0.25, 14.45],
      ['Q2 2015', 0.4, 17.79],
      ['Q3 2015', 0.31, 19.91],
      ['Q4 2015', 1.35, 26.72],
      ['Q1 2016', 1.76, 32.29],
      ['Q2 2016', 2.82, 35.47],
      ['Q3 2016', 0.77, 33.93],
      ['Q4 2016', 1.71, 48.51],
      ['Q1 2017', 2.03, 38.15],
      ['Q2 2017', 0.52, 41.78]
    ]
    
    rows = {
      pos: data.last(9).map(&:first),
      all: data.map(&:first)
    }
    
    series_labels = ['Amazon Profit Margin (% Sales)', 'Facebook Profit Margin (% Sales)']
    single_series_labels = series_labels.first(1)
    
    single_coll_pos = data.last(9).map { |row| row[1, 1] }
    multi_coll_pos = data.last(9).map { |row| row[1..-1] }
    
    single_coll_xy = data.map do |row| 
      x = quarter_to_date(row.first)
      [[x, row[1]]]
    end
    multi_coll_xy = data.map do |row| 
      x = quarter_to_date(row.first)
      [[x, row[1]], [x, row[2]]]
    end
    
    data_formatters = %i[none delimiter]

    single_xy_base = { 
      collection: single_coll_xy, 
      options: { rows: rows[:all], series_labels: single_series_labels, title: 'Scatter Plot', 
                 data_formatters: data_formatters } 
    }
    multi_xy_base = { 
      collection: multi_coll_xy, 
      options: { rows: rows[:all], series_labels: series_labels, title: 'Multi-Series Scatter Plot', 
                 data_formatters: data_formatters } 
    }
    
    @args = {
      bar: { 
        collection: single_coll_pos, 
        options: { rows: rows[:pos], series_labels: single_series_labels, title: 'Bar Chart' } 
      },
      multi_bar: { 
        collection: multi_coll_pos, 
        options: { rows: rows[:pos], series_labels: series_labels, title: 'Multi-Series Bar Chart' } 
      },
      
      scatter: single_xy_base,
      multi_scatter: multi_xy_base,
      line: single_xy_base,
      multi_line: multi_xy_base,
      
      tiny: { collection: [[1], [2], [3]], options: { height: 200 } },
      tiny_xy: { 
        collection: [[[1, 1]], [[2, 2]], [[2.5, 1.2]], [[2.8, 1.7]], [[3, 3]], [[3.2, 2]]], 
        options: { height: 160, width: 200 } 
      }
    }
    
    @args[:line][:options][:title] = 'Line Chart'
    @args[:multi_line][:options][:title] = 'Multi-Series Line Chart'
    
    render layout: 'plain'
  end
  
  private
  
  def render_scatter
    render 'scatter'
  end
  
  def quarter_to_date(quarter)
    quarter = quarter.split(' ')
    quarter.first[1].to_i * 0.25 + quarter.last.to_i
  end
end
