class WordsController < ApplicationController
  def index
    pub_to_label = proc { |pub| pub.to_s.titleize + ' Word Count' }
    columns = %i[start_date new_york_times wall_street_journal washington_post]
    options = { 
      width: 1000, data_formatters: %i[date delimiter], series_labels: columns.last(3).map(&pub_to_label)
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
