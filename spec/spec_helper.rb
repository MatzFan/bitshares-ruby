$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'bitshares'

Bitshares.configure(wallets: {test1: 'password1', test2: 'password2'})
