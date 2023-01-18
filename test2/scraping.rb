require 'uri'
require 'net/http'
require 'json'
require 'nokogiri'
require 'json'

uri = URI('https://www.nasa.gov/api/2/ubernode/479003')

res = Net::HTTP.get(uri)
data = JSON.parse(res) 
source = data["_source"]

title = source["title"]
date = source["promo-date-time"]
release_id = source["release-id"]

parsed_data = Nokogiri::HTML.parse(source["body"])

body = parsed_data.search('p')

p_ele = ""

body.each do |item|
  if 
  p_ele += item.to_s.delete("<p></p>") + "\n"
end

hash = {:title => title, :date => date, :release_no => release_id, :article => p_ele}

puts JSON.generate(hash)
