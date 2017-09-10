namespace :words do
  desc 'Scrape date(s) specified for word frequency on news sites'
  task :scrape, [:start_date, :snapshots] => :environment do |_, args|
    start_date = Date.new(*args.start_date.split('-').map(&:to_i))
    end_date = start_date + (args.snapshots.to_i - 1).days
    USER_AGENT = 'https://github.com/saaineui/necker'
    
    terms = ['alt-right', 'identity politics'].map do |word|
      new_word = Word.create(word: word, start_date: start_date, snapshots: args.snapshots.to_i)
      puts new_word.name + ' created.'
      new_word
    end
    
    until terms.last.complete?
      begin
        (start_date..end_date).each_with_index do |date, index|
          Word::MEDIA.each do |column, d|
            # raise error if term snapshots do not match?
            
            if date <= (start_date + (terms.first.send(d[:snapshots]) - 1).days)
              puts "#{column} on #{date.strftime('%F')} skipped"
              next
            end
            
            currently_fetching = "https://web.archive.org/web/#{date.strftime('%Y%m%d')}170000/https://www.#{d[:site]}"
            
            puts 'Currently fetching ' + currently_fetching
            
            res = HTTPClient.new(
              default_header: { "User-Agent" => USER_AGENT }
            ).get(
              currently_fetching, 
              follow_redirect: true
            )

            raise HTTPClient::BadResponseError if res.body.nil? || !res.code.eql?(200)
            homepage = Nokogiri::HTML(res.body)
            homepage = homepage.xpath('//body').first.inner_text.to_s.gsub(/\s+/, ' ')

            terms.each do |term|
              current_term_count = homepage.scan(term.reg_exp).count
              puts "#{term.word} found #{current_term_count} times in #{column} on #{date.strftime('%F')}"
              
              new_term_count = term.send(column) + current_term_count
              new_snapshots = term.send(d[:snapshots]) + 1
              term.update(column => new_term_count, d[:snapshots] => new_snapshots)
              
              puts "#{term.word} updated: #{column} #{new_term_count}, #{d[:snapshots]} #{new_snapshots}"
            end

            sleep(1)
          end
        end
      rescue => e
        puts e.message
      end
      
      sleep(60) unless terms.last.complete?
    end
  end
end
