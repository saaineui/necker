class WordsController < ApplicationController
  def index
    columns = %i[start_date new_york_times wall_street_journal washington_post]
    options = { 
      width: 1000, data_formatters: %i[date delimiter]
    }
    
    @args = ['alt-right', 'identity politics'].map do |word|
      {
        collection: Word.where(word: word).order(:start_date), 
        columns: columns,
        options: options.merge(title: "#{word} on News Homepages")
      }
    end
  end
end
