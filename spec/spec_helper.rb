$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bitshares'

abort 'bitshares client not running!' if `pgrep bitshares_clien`.empty? # 15 ch

Bitshares.configure(wallets: {test1: 'password1'})

include_cost = ENV['BITSHARES_INCLUDE_TESTS_WITH_COSTS'] == 'true'
RSpec.configure { |c| c.filter_run_excluding :type => 'cost' } if !include_cost
