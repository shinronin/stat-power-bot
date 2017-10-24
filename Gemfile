ruby_version = File.read("#{File.dirname(__FILE__)}/.ruby-version").chomp
# puts "Bundling for ruby version: #{ruby_version}"
ruby ruby_version

source 'https://rubygems.org'

# Use pkg-config and ENV variable PKG_CONFIG_PATH to help nokogiri install properly
gem 'pkg-config'
# Install first to avoid dependency collisions
gem 'nokogiri'

# Discord API
gem 'discordrb'
# Extra... support
gem 'activesupport'
# Commify numbers
gem 'actionview'
# Better debugging than puts
gem 'awesome_print'
# Stop arguing about style and learn better Ruby idioms
gem 'rubocop'
# CLI tools
gem 'trollop'
# Concurrent http requests
gem 'typhoeus'
