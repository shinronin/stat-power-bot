# #!/usr/bin/env ruby

require 'rubygems'
require 'bundler/setup'

require 'trollop'

# require 'action_view'
# require 'ap'
# require 'json'
# require 'nokogiri'
# require 'typhoeus'

# require 'bot/player'
# require 'bot/guild'
# require 'bot/http'

# TODO: trollop
opts = Trollop::options do
  opt :player,     'IGN'
  opt :guild_id,   'Guild id',   type: :integer
  opt :guild_name, 'Guild name', type: :string
  conflicts :player, :guild_id
  conflicts :player, :guild_name
  depends :guild_id, :guild_name
end
# Trollop::die

# id && name ? Bot::Guild.new(id: id, name: name).run : Bot::Player.new(player: player).run
# Bot::Player.new(player: player).run
