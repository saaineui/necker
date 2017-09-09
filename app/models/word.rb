class Word < ApplicationRecord
  validates :name, :word, :match_exp, :start_date, :snapshots, 
            :new_york_times, :wall_street_journal, :washington_post, 
            :nyt_snapshots, :wsj_snapshots, :wapo_snapshots, presence: true
  
  before_validation :name_record, :match_exp_from_word, unless: :persisted?
  
  MEDIA = { 
    new_york_times: 'nytimes.com', 
    wall_street_journal: 'wsj.com', 
    washington_post: 'washingtonpost.com'
  }.freeze
  
  private
  
  def name_record
    return false unless pretty_time_period
    
    self.name = "#{word} (#{pretty_time_period})"
  end
  
  def match_exp_from_word
    return false unless word && match_exp.nil?
    
    self.match_exp = word.gsub(/(-| )/) { |match| '\s*(-|\+)?\s*' }
  end
  
  def pretty_time_period
    return false unless start_date && snapshots
    
    if start_date.day.eql?(1)
      case snapshots
      when 90..91
        quarters = { 1 => 1, 4 => 2, 7 => 3, 10 => 4 }
        
        if quarters.key?(start_date.month)
          return "Q#{quarters[start_date.month]} #{start_date.year}" 
        end
      when 28..29
        return start_date.strftime('%B %Y') if start_date.month.eql?(2)
      when 30
        return start_date.strftime('%B %Y') if [4, 6, 9, 11].include?(start_date.month)
      when 31
        return start_date.strftime('%B %Y') if [1, 3, 5, 7, 8, 10, 12].include?(start_date.month)
      when 365..366
        return start_date.strftime('%Y') if start_date.month.eql?(1)
      end
    end
    
    return start_date.strftime('%F') if snapshots.eql?(1)
        
    [start_date.strftime('%F'), (start_date + (snapshots - 1).days).strftime('%F')].join(' - ')
  end
end
