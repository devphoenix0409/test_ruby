require 'rubygems'
require 'pdf/reader'
require 'json'

filename = File.expand_path(File.dirname(__FILE__)) + "/17423_2019-07-08_N11.pdf"

text = ""

PDF::Reader.open(filename) do |reader|
  reader.pages.each do |page|
    text = page.text
  end
end

myarray = text.split(/\n/, -1)
name = myarray[3].delete(").,").strip
address = myarray[11].delete(").,").strip
date = myarray[13].delete(").,").split(':').last.split
price = text[/\$.*/].split(' ')[0]

hash = {:petitioner => name, :state => address, :amount => price, :date => date}

puts JSON.generate(hash)