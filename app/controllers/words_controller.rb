class WordsController < ApplicationController
  def index
    columns = %i[start_date new_york_times wall_street_journal washington_post]
    options = { 
      width: 1000, data_formatters: %i[date delimiter]
    }
    
    @alt_right = {
      collection: Word.all.order(:start_date), 
      columns: columns,
      options: options.merge(title: '"alt-right" on News Homepages')
    }

    @identity = {
      collection: Word.all.order(:start_date), 
      columns: columns,
      options: options.merge(title: '"identity politics" on News Homepages')
    }
  end
end
