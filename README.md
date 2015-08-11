# Bitshares Ruby Gem

This Gem provides a Ruby API for the BitShares command line client by exposing the RPC commands of the [Bitshares client v0.x](https://github.com/bitshares/bitshares) as methods of it's Client class.

The binary client; "bitshares_client" must be installed, configured and running. The Gem detects the port the HTTP JSON RPC server is running on and expects the RPC endpoint to be `localhost` for security reasons - see [Configuration file settings](http://wiki.bitshares.org/index.php/BitShares/API).

## Requirements

_Important:_ The interface uses the command line binary, not the GUI app.
Tested with v0.9.2 client on Mac OS X (10.9.5) and Ubuntu 14.04. Should work on any *NIX platform - sorry not Windows.

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

RPC server login credentials (registered account name and password) must be stored in the following environment variables:-

  `$BITSHARES_ACCOUNT`

  `$BITSHARES_PASSWORD`

## Configuration

The Gem allows multiple wallet names and passwords to be stored so that actions requiring these data may be automated.
To use this functionality - i.e. with the Wallet class (see below) wallet names and passwords must be configured in either of the following ways:

**Via a hash**
```Ruby
Bitshares.configure(:wallet => {:name => 'wallet1', :password => 'password1'})
Bitshares.configure(:wallet => {:name => 'wallet2', :password => 'password2'})
...
```

**From a Yaml configuration file**
```Ruby
Bitshares.configure_with(<path to Yaml file>) # 'wallets' and 'passwords' keys and array values must be used, as above
```

```Ruby
Bitshares.config # returns the configuration hash
```

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

Data is returned as a hash

### Detailed usage

**Blockchain**

The blockchain is implemented as a class purely for convenience when calling 'blockchain_' methods:
```Ruby
chain = Bitshares::Blockchain
count = chain.get_block_count # equivalent to `client.blockchain_get_block_count`
```

**Wallet**

```Ruby
wallet = Bitshares::Wallet.new 'wallet1' # opens a wallet available on this client.
```
Note that the following command opens the named wallet, but does not return an instance of Wallet class - use Wallet.new
```Ruby
wallet.open 'wallet1'
```

Thereafter 'wallet_' commands may be issued like this:
```Ruby
wallet.get_info # gets info on this wallet, equivalent to client.wallet_get_info
wallet.transfer(amount, asset, from, recipient) # equivalent to - you get the picture..
```
A wallet is unlocked and closed in a similar fashion:
```Ruby
wallet.unlock
wallet.close
```

Predicates are provided for convenience:
```Ruby
wallet.open?
wallet.unlocked?
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

_Important:_ There is currently no sandbox, so the test suite runs on your live client. If this concerns you - and it should :scream: - feel free to browse the code. In particular, the following client 'fixtures' are required for the full test suite to run and pass:

An empty wallet 'test1', with password 'password1'

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/MatzFan/bitshares-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

