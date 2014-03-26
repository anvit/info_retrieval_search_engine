require 'rubygems'
require 'nokogiri'
require 'open-uri'

def get_href(page,selector)
   doc = Nokogiri::HTML(open(page))
   hrefs = doc.css(selector).map do |link|
    if (href = link.attr("href")) && !href.empty?
      URI::join(page, href)
    end
   end.compact.uniq
   return hrefs
 end

test = 'http://www.dmoz.org/Sports/Cricket/ICC/Affiliate_Members/Austria/'
links = []
ref = []
temp = []
lit = 'http://www.dmoz.org/Arts/Literature/'
hawking = 'http://www.dmoz.org/Science/Astronomy/'
chan = 'http://www.dmoz.org/Sports/Martial_Arts/'
bsnl4ka = 'http://www.dmoz.org/Sports/Cricket/'
# ref = get_href('','div.dir-1 a')
# ref = get_href('http://www.dmoz.org/Science/Astronomy/','a.listinglink')
temp = get_href(lit,'div.dir-1 a')
temp.each { |url| 
	if !url.nil?
		ref.push(url)
	end
}
temp = get_href(lit,'a.listinglink')
temp.each { |url| 
	if !url.nil?
		links.push(url)
	end
}
puts "Links: "
puts links
puts "Refs: "
puts ref
# ref.each{ |url|
	
# }