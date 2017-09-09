namespace :words do
  desc 'Scrape date(s) specified for word frequency on four sites'
  task :scrape, [:when] => :environment do |_, args|
    begin
      ['alt-right', 'anti-establishment'].each do |word|
        new_word = Word.create(word: word, start_date: Date.new(*args.when.split('-').map(&:to_i)), snapshots: 1)
        puts new_word.name + ' created.'

        match_exp = Regexp.new('\b' + new_word.match_exp + '\b', true)
        
        Word::MEDIA.each do |column, site|
          sleep(1)
          res = HTTPClient.new.get(
            "https://web.archive.org/web/#{args.when.gsub('-','')}170000/#{site}", 
            follow_redirect: true
          )

          raise HTTPClient::TimeoutError if res.body.nil? || !res.code.eql?(200)
          homepage = Nokogiri::HTML(res.body)
          homepage = homepage.xpath('//body').first.inner_text.to_s.gsub(/\s+/, ' ')
          new_count = new_word.send(column) + homepage.scan(match_exp).count
          puts new_count

          new_word.update(column => new_count)
        end
      end
    rescue HTTPClient::TimeoutError 
      res_code = res && res.respond_to?(:code) ? res.code : 'no code'
      puts 'Timeout Error or Empty Body: ' + res.code.to_s
    end
  end
end
