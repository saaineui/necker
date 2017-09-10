class WordsController < ApplicationController
  def index
    columns = %i[new_york_times wall_street_journal washington_post]
    options = {
      bar_width: 80,
      single_y_scale: true
    }

    @alt_right = {
      collection: Word.where(word: 'alt-right').order(:start_date), 
      columns: columns,
      options: options.merge(title: '"alt-right" on News Homepages')
    }
    
    @identity = {
      collection: Word.where(word: 'identity politics').order(:start_date), 
      columns: columns,
      options: options.merge(title: '"identity politics" on News Homepages')
    }
  end
end
