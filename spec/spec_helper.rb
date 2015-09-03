$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bitshares'

abort 'cli_wallet not running!' if `pgrep cli_wallet`.empty? # 15 ch

Bitshares.configure(wallets: {test1: 'password1'})

include_cost = ENV['BITSHARES_INCLUDE_TESTS_WITH_COSTS'] == 'true'
RSpec.configure { |c| c.filter_run_excluding :type => 'cost' } if !include_cost
