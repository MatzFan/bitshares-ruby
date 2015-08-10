# Bitshares Ruby Gem

This Gem is a Ruby API for the BitShares command-line client. It exposes the commands provided by the [Bitshares client v0.x](https://github.com/bitshares/bitshares) via it's JSON RPC interface.

The binary client 'bitshares_client' must be installed, configured and running. The Gem detects the port the HTTP JSON RPC server is running on and expects the RPC endpoint to be `localhost` for security reasons - see [Configuration file settings](http://wiki.bitshares.org/index.php/BitShares/API).

## Requirements

_Important:_ The interface uses the commandline binary, not the GUI app.
Tested with v0.9.2 client on Mac OS X (10.9.5) but should work and any *NIX platform - sorry not Windows.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bitshares-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitshares-ruby

## Authentication

Login credentials for your BitShares wallet must be stored in the following environment variables:-

  $BITSHARES_USER
  $BITSHARES_PWD

## Usage

### Quick start

```ruby
require 'bitshares'

client = Bitshares::Client.new
```
Any valid client command can then be issued via a method call with relevant parameters - e.g.

```ruby
client.get_info
client.wallet_open 'default'
client.blockchain_list_delegates
client_wallet_market_submit_bid(account, amount, quote, price, base)
...
```

Data is returned as a Hash

## Testing and specification

`rake spec`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MatzFan/bitshares-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

