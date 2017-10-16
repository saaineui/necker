class WordsController < ApplicationController
  def index
    columns = %i[new_york_times wall_street_journal washington_post]
    options = {
      bar_width: 45,
      single_y_scale: true,
      max_values: Array.new(3, Word.all.pluck(*columns).flatten.max)
    }
    
    ranges = {
      'January 2016 - July 2016' => Date.new(2016, 1, 1)..Date.new(2016, 7, 31),
      'August 2016 - February 2017' => Date.new(2016, 8, 1)..Date.new(2016, 2, 29),
      'March 2017 - September 2017' => Date.new(2017, 3, 1)..Date.new(2017, 9, 30)
    }
    
    @alt_right = []
    @identity = []
    
    ranges.each do |name, range|
      @alt_right << {
        collection: Word.where(word: 'alt-right', start_date: range).order(:start_date), 
        columns: columns,
        options: options.merge(title: '"alt-right" on News Homepages (' + name + ')')
      }

      @identity << {
        collection: Word.where(word: 'identity politics', start_date: range).order(:start_date), 
        columns: columns,
        options: options.merge(title: '"identity politics" on News Homepages (' + name + ')')
      }
    end
  end
end
