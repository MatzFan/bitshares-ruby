# Bitshares Ruby Gem

This Gem provides a Ruby API for the BitShares command line client by exposing the RPC commands of the [Bitshares client v0.x](https://github.com/bitshares/bitshares) as methods of it's Client class.

The binary client; "bitshares_client" must be installed, configured and running. The Gem detects the port the HTTP JSON RPC server is running on and expects the RPC endpoint to be `localhost` for security reasons - see [Configuration file settings](http://wiki.bitshares.org/index.php/BitShares/API).

## Requirements

_Important:_ The interface uses the command line binary, not the GUI app.
Tested with v0.9.2 client on Mac OS X (10.9.5) and Ubuntu 14.04. Should work on any *NIX platform - sorry not Windows.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bitshares'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bitshares

## Authentication

RPC server login credentials (registered account name and password) must be stored in the following environment variables or set in the configuation (see below):-

  `$BITSHARES_ACCOUNT`

  `$BITSHARES_PASSWORD`

## Configuration

Config settings may be set via a hash or Yaml file.

**Via a hash**

RPC server login credentials may be set as follows:
```Ruby
Bitshares.configure(:rpc_username => 'whatever')
Bitshares.configure(:rpc_password => 'whatever')
```

The Gem allows multiple wallet names and passwords to be stored so that actions requiring these data may be automated.
To use this functionality - i.e. with the Wallet class (see below) wallet names and passwords must be configured in either of the following ways:

```Ruby
Bitshares.configure(:wallet => {'wallet1' => 'password1'})
Bitshares.configure(:wallet => {'wallet2' => 'password2'})
...
```

**From a Yaml configuration file**
```Ruby
Bitshares.configure_with 'path-to-Yaml-file'
```

```Ruby
Bitshares.config # returns the configuration hash
```

## Usage

### Quick start

```ruby
require 'bitshares'

client = CLIENT.init # CLIENT = Bitshares::Client -the object BitShares RPC client calls are routed to.
client.synced? # if you wish to check whether you are synced with the p2p network.
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
chain = Bitshares::Blockchain # CHAIN may be used
count = chain.get_block_count # equivalent to client.blockchain_get_block_count
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

Once you have a wallet instance you can do the following, which references a particular wallet account:
```Ruby
account = wallet.account 'account_name'
```
Thereafter all 'wallet_account_' client commands may be issued without specifying the account_name parameter:
```Ruby
account.balance # balance for a particular account
account.order_list # optional [limit] param
account_register(pay_from_account [, optional params]) # this command takes up to 3 optional params
```
'wallet_account_' client commands taking an *optional* account_name parameter list all data for all of a wallet's accounts. If this is required, the relevant Wallet method should be used - e.g:
```Ruby
wallet.account_balance # lists the balances for all accounts for this wallet (c.c. above)
```

**Market**

The market class represents the trading (order book and history) for a given an asset-pair - e.g. CNY/BTS. It is instantiated like this:
```Ruby
cny_bts = Bitshares::Market.new('CNY', 'BTS')
```
_Note that the BitShares market convention is that quote asset_id > base asset_id. Reversing the symbols in the above example results in the client returning  an 'Invalid Market' error._ An asset's id can be found from the asset hash by using:
```Ruby
Bitshares::Blockchain.get_asset 'CNY' # for example
```

The following 'blockchain_market_' client methods may then be used without specifying the quote and base assets again, but with any other optional args the client accepts:
```Ruby
cny_bts.list_asks # equivalent to blockchain_market_list_asks(quote, base) [limit]
cny_bts.list_bids
cny_bts.list_covers
cny_bts.order_book
cny_bts.order_history
cny_bts.price_history # required params are: <start time> <duration> optional: [granularity]

cny_bts.list_shorts # requires no params and ignores the base asset
cny_bts.get_asset_collateral # requires no params and returns the collateral for the quote asset (ignores the base asset)
```

Additionally, the following methods are available:
```Ruby
cny_bts.lowest_ask
cny_bts.highest_bid
cny_bts.mid_price # mean of the above
cny_bts.last_fill # price of the last filled order
```

**Trading**

So, once we have an account and a market, what do we need to trade - why a Trader of course!

```Ruby
cny_bts_trader = Bitshares::Trader.new(account, cny_bts) # using examples above
```

You can now do this:
```Ruby
cny_bts_trader.order_list # lists orders for the account and market - optional limit arg. Returns orders array

cny_bts_trader.submit_bid(quantity, price) # buy <quantity> of Market base (BTS here) at <price> (quote/base)
cny_bts_trader.submit_ask(quantity, price) # sell <quantity> of Market base (BTS here) at <price> (quote/base)
  # both return respective order id

cny_bts_trader.cancel_orders(*order_ids) # cancels one or more orders for the account and market
  # returns array of memo's e.g. 'cancel ASK-90189b6e'
```

## Specification & tests

For the full specification clone this repo and run:

`rake spec`

**Test Requirements**

There is currently no test blockchain, so the test suite runs on the live one - orders and all. If this concerns you - and it should :scream: - feel free to browse the test code first. The following client 'fixtures' are required for the full test suite to run and pass:

An empty wallet 'test1', with password 'password1' and an account called 'account-test' *Please don't register this account!*. The account will also need funding with a few BTS as trades/cancellations are 0.5 BTS each. 10 BTS (circa 2.5 cents right now) should be more than enough to run the suite a few times.

## Contributing

Bug reports, pull requests (and feature requests) are welcome on GitHub at https://github.com/MatzFan/bitshares-ruby.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

