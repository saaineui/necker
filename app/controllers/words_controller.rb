class WordsController < ApplicationController
  def index
    columns = %i[new_york_times wall_street_journal washington_post]
    bar_width = 80
    
    @alt_right = {
      collection: Word.where(word: 'alt-right'), 
      columns: columns,
      options: { title: '"alt-right" on News Homepages', bar_width: bar_width }
    }
    
    @identity = {
      collection: Word.where(word: 'identity politics'), 
      columns: columns,
      options: { title: '"identity politics" on News Homepages', bar_width: bar_width }
    }
  end
end
