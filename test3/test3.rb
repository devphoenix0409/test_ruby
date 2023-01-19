require 'rubygems'
require 'pdf/reader'
require 'nokogiri'
require "pdfcrowd"
require 'json'

def get_html_as_string(filename)
  data = ''
  f = File.open(filename, "r") 
  f.each_line do |line|
    data += line
  end
  return data
end

filename = "S17525_2020-03-05_N1.pdf"
htmlname = "" + filename

htmlname.gsub! 'pdf', 'html'

begin
    client = Pdfcrowd::PdfToHtmlClient.new("Cloud", "8436ce68a87168b7408616e29ff19b23")

    client.convertFileToFile(File.expand_path(File.dirname(__FILE__)) + "/" + filename, htmlname)
rescue Pdfcrowd::Error => why
    STDERR.puts "Pdfcrowd Error: #{why}"

    raise
end

html_content = get_html_as_string htmlname

parsed_data = Nokogiri::HTML.parse(html_content)

div_name = parsed_data.css('div.t.m0.x2.h2.y2')

div_location = parsed_data.css('div.t.m0.x2.h2.y7')

if div_location.length == 0
  div_location = parsed_data.css('div.t.m0.x2.h2.y5')
end

if div_location.length == 0
  div_location = parsed_data.css('div.t.m0.x2.h2.y6')
end

if div_location.length == 0
  div_location = parsed_data.css('div.t.m0.x2.h2.y8')
end

div_name.each do |container|
  name = container.content
  puts name
end

div_location.each do |container|
  location = container.content
  puts location
end

text = ""
file = File.expand_path(File.dirname(__FILE__)) + "/" + filename

PDF::Reader.open(file) do |reader|
  reader.pages.each do |page|
    text += page.text
    text += "\n"
  end
end

str = text
price = str.match(/(\$\d{1,5}\.\d{1,5})/)[0]
puts price

date = str.match(/(\d{1,2}\/\d{1,2}\/\d{1,4})/)[0]
puts date