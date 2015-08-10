# Bitshares Ruby Gem

This Gem provides a Ruby API for the BitShares command line client by exposing the RPC commands of the [Bitshares client v0.x](https://github.com/bitshares/bitshares) as methods of it's Client class.

The binary client; "bitshares_client" must be installed, configured and running. The Gem detects the port the HTTP JSON RPC server is running on and expects the RPC endpoint to be `localhost` for security reasons - see [Configuration file settings](http://wiki.bitshares.org/index.php/BitShares/API).

## Requirements and limitations

_Important:_ The interface uses the command line binary, not the GUI app.
Tested with v0.9.2 client on Mac OS X (10.9.5) and Ubuntu 14.04. Should work on any *NIX platform - sorry not Windows.

Currently the Gem supports single wallet support/authentication - see Authentication below

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

  `$BITSHARES_USER`

  `$BITSHARES_PASSWORD`

## Usage

### Quick start

```ruby
require 'bitshares'

client = Bitshares::Client.init # The object BitShares RPC client calls are routed to.
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

### Detailed usage

**Blockchain**

The blockchain is implemented as a class purely for convenience when calling 'blockchain_' methods:
```Ruby
chain = Bitshares::Blockchain
count = chain.get_block_count # equivalent to `client.blockchain_get_block_count`
```

**Wallet**

```Ruby
wallet = client.open 'wallet1' # opens a wallet available on this client.
```
Thereafter 'wallet_' commands may be issued like this:
```Ruby
wallet.get_info # gets info on this wallet, equivalent to client.wallet_get_info 
wallet.transfer(amount, asset, from, recipient) # equivalent to - you get the picture..
```
A wallet is closed through the client:
```Ruby
client.close
```

**Account**

Once you have a wallet instance you can do this:
```Ruby
account = wallet.account 'account_name'
```
Thereafter 'wallet_account_' commands may be issued like this:
```Ruby
account.balance
account.register(account_name, pay_from)
```

**Market**

The market class represents the trading (order book and history) for a given an asset-pair - e.g. CNY/BTS. It is instantiated like this:
```Ruby
market = Bitshares::Market.new(CNY, BTS)
```
Any 'blockchain_market_' client method may then be used without specifying the quote and base assets again e.g:
```Ruby
market.list_bids
market.order_history
```

## Testing and specification

`rake spec`

_Important:_ There is curerentlt no sandbox, so the test suite runs on your live client. If this concerns you - and it should :scream: - feel free to browse the code. In particular, the following client 'fixtures' are required for the full test suite to run and pass:

An empty wallet 'test1', with password 'password1'

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MatzFan/bitshares-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

