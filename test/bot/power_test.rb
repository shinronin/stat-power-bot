require 'test_helper'

module Bot
  class PowerTest < ActiveSupport::TestCase
    def setup
    end

    test 'constructor' do
      p = Bot::Power.new player: 'shinronin'
    end
  end
end
