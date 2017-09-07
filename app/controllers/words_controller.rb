class WordsController < ApplicationController
  def index
    columns = %i[new_york_times wall_street_journal cnn washington_post]
    
    @alt_right = {
      collection: Word.where(word: 'alt-right'), 
      columns: columns,
      options: { title: '"alt-right" in Major Media' }
    }
    
    @anti_establishment = {
      collection: Word.where(word: 'anti-establishment'), 
      columns: columns,
      options: { title: '"anti-establishment" in Major Media' }
    }
  end
end
