require 'anemone'
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'addressable/uri'

def get_href(page,selector)
   	begin
		file = open(page)
		doc = Nokogiri::HTML(file)
		hrefs = doc.css(selector).map do |link|
			if (href = link.attr("href")) && !href.empty?
				uri = Addressable::URI.parse(href)
				Addressable::URI.join(page, uri)
			end
		end.compact.uniq
		return hrefs
	rescue OpenURI::HTTPError => e
		if e.message == '404 Not Found'
		   	puts "exception on url: #{page}"
		else
			raise e
		end
	end
 end

links = []
temp = []
u_link = 'a.listinglink'
lit = 'http://www.dmoz.org/Arts/Literature/'
hawking = 'http://www.dmoz.org/Science/Astronomy/'
chan = 'http://www.dmoz.org/Sports/Martial_Arts/'
bsnl4ka = 'http://www.dmoz.org/Sports/Cricket/'
pat = Regexp.union /\/World\// , /\/docs\//, /\/public\// #ignore these url patterns
Anemone.crawl(chan, :discard_page_bodies => true) do |anemone|
  anemone.skip_links_like pat
  anemone.on_pages_like(/\/Sports\/Martial_Arts\//) do |page| #URL pattern to fetch
  	puts page.url
  	temp = get_href(page.url.to_s,u_link) #fetch external links from current url
  	if !temp.nil? 
		temp.each { |url| 
			if !url.nil?
				links.push(url)
			end
			File.open("chan_index.txt", "w") do |f|
			  f.puts(links.uniq)
			end
		}
	end
  end
end