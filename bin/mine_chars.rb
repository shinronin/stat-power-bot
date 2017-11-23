#!/usr/bin/env ruby

require 'bundler/setup'
require 'ap'
require 'nokogiri'

doc = Nokogiri::HTML File.read(File.join(Bundler.root, 'test/fixtures/characters.html'))
data = doc.css('li.character/a').each_with_object({}) do |n, memo|
  name = n.css('div/h5').text
  power = n.css('p.hidden-xs/strong').map { |n| n.children.first.text }.each_slice(3).map(&:first).first
  memo.key?(power) ? memo[power] << name : memo[power] = [name]
end

data.keys.sort.reverse.each do |k|
  puts "#{k}: #{data[k].sort.join(', ')}"
end
