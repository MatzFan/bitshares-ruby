require 'spec_helper'

describe Bitshares::Trader do

  before { CLIENT.init }
  before { Bitshares.configure({wallet: {'test1' => 'password1'}}) }

  let(:wallet) { Bitshares::Wallet.new 'test1' }
  let(:account) { Bitshares::Account.new(wallet, 'account-test') }
  let(:cny_bts) { Bitshares::Market.new('CNY', 'BTS') }
  let(:cny_bts_trader) { Bitshares::Trader.new(account, cny_bts) }

  context '#new(account, market)' do
    it 'instantiates an instance of the class with an Account and a Market object' do
      expect(cny_bts_trader.class).to eq Bitshares::Trader
    end
  end

  context '#submit_bid(quantity, price, [stupid = false])', :type => :cost do
    it 'submits an order to buy <quantity> of Market base at <price> (quote/base) and returns the order id' do
      begin
        cny_bts_trader.submit_bid(1, 0.001) # buy 1 BTS @ 0.001 CNY/BTS
      rescue CLIENT::Err => e
      end
      expect(e.to_s).to include 'insufficient funds' # no CNY in account
    end
  end

  context '#submit_ask(quantity, price, [stupid = false])', :type => :cost do
    it 'submits an order to sell <quantity> of Market base at <price> (quote/base) and returns the order id' do
      expect(cny_bts_trader.submit_ask(1, 2)).to match /^[a-f\d]{40}$/i # sell 1 BTS @ 2 CNY/BTS
    end
  end

  context '#order_list([limit = -1])' do
    it 'lists open orders for the account and market, with optional limit arg. Each order consists of a 2 element array; order id & hash' do
      orders = cny_bts_trader.order_list
      expect(orders.all? { |o| o.first.match(/^[a-z0-9]{40}$/i) && o.last.class == Hash }).to be true
    end
  end

  context '#cancel_orders(*order_ids)', :type => :cost do
    it 'cancels one or more orders and returns list of memo entries - e.g. ["cancel ASK-90189b6e", cancel...]' do
      ids = cny_bts_trader.order_list.map &:first
      expect(cny_bts_trader.cancel_orders ids).to eq ids.map { |id| "cancel ASK-#{id[0...8]}" }
    end
  end

end
