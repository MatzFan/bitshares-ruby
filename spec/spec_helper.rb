$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bitshares'

Bitshares.configure(wallets: {test1: 'password1'})

puts 'Include tests with a cost? (Y/n)'
resp = STDIN.gets.chomp
RSpec.configure { |c| c.filter_run_excluding :type => 'cost' } if resp != 'Y'
