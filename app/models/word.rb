class Word < ApplicationRecord
  validates :name, :word, :match_exp, :start_date, :snapshots, 
            :new_york_times, :wall_street_journal, :washington_post, 
            :nyt_snapshots, :wsj_snapshots, :wapo_snapshots, presence: true
  
  before_validation :name_record, :match_exp_from_word, unless: :persisted?
  
  MEDIA = { 
    new_york_times: { site: 'nytimes.com', snapshots: :nyt_snapshots },
    wall_street_journal: { site: 'wsj.com', snapshots: :wsj_snapshots },
    washington_post: { site: 'washingtonpost.com', snapshots: :wapo_snapshots }
  }.freeze
  
  def complete?
    site_snapshots_columns.all? { |column| snapshots.eql?(column) }
  end
  
  def reg_exp
    return false unless match_exp.is_a?(String)
    
    Regexp.new('\b' + match_exp + '\b', true)
  end
  
  private
    
  def site_snapshots_columns
    MEDIA.values.map { |d| send(d[:snapshots]) }
  end
  
  def name_record
    return false unless pretty_time_period
    
    self.name = "#{word} (#{pretty_time_period})"
  end
  
  def match_exp_from_word
    return false unless word && match_exp.nil?
    
    self.match_exp = word.gsub(/(-| )/) { '\s*(-|\+)?\s*' }
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
