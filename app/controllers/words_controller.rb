class WordsController < ApplicationController
  def index
    columns = %i[new_york_times wall_street_journal washington_post]
    options = {
      bar_width: 55,
      single_y_scale: true
    }
    
    ranges = {
      '2016' => Date.new(2016, 1, 1)..Date.new(2016, 12, 31),
      '2017' => Date.new(2017, 1, 1)..Date.new(2017, 12, 31)
    }
    
    @alt_right = {}
    @identity = {}
    
    ranges.each do |year, range|
      @alt_right[year] = {
        collection: Word.where(word: 'alt-right', start_date: range).order(:start_date), 
        columns: columns,
        options: options.merge(title: '"alt-right" on News Homepages (' + year + ')')
      }

      @identity[year] = {
        collection: Word.where(word: 'identity politics', start_date: range).order(:start_date), 
        columns: columns,
        options: options.merge(title: '"identity politics" on News Homepages (' + year + ')')
      }
    end
  end
end
