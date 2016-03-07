require 'scraperwiki'
require 'mechanize'

agent = Mechanize.new
page  = agent.get('http://bookstore.yahoo.co.jp/free_magazine-166178/')
lis   = page.search('#provideBooksList > li')

p lis.size

data = lis.map do |li|
  a = li.at('.provideBooksTitle > a')
  {:link    => 'http://viewer.bookstore.yahoo.co.jp/?u0=3&cid=' +
               a['href'][/\d+/],
   :title   => a.text,
   :content => li.at('.provideBooksText').text,
   :author  => li.at('.author').text,
   :date    => li.at('.term0Magazine').text.scan(/\d+/)[0..2]*'-'+'T00:00:00Z',
  }
end

ScraperWiki.save_sqlite [:link], data
