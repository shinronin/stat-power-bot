require 'rubygems'
require 'bundler/setup'

require 'action_view'
require 'ap'
require 'json'
require 'nokogiri'
require 'typhoeus'

require './bot/http'
require './bot/power'

BASE_URL = 'https://swgoh.gg'.freeze

user = ARGV.shift || 'shinronin'
bp = Bot::Power.new user: user
bp.run
