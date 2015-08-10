require 'spec_helper'

describe Bitshares::Market do

  before { Bitshares::Client.init }

  let(:market) { Bitshares::Market.new('CNY', 'BTS') }

  MULTIPLIER = 10 # for this asset pair

  context '#new(quote, base)' do
    it 'raises AssetError "No such asset: <symbol(s)>" if an invalid asset symbol is used' do
      expect(->{Bitshares::Market.new('BTC', 'GARBAGE')}).to raise_error Bitshares::Market::AssetError, 'No such asset: GARBAGE'
    end

    it 'instantiates an instance of the class with valid asset symbols (case insensitive)' do
      expect(Bitshares::Market.new('BTC', 'btS').class).to eq Bitshares::Market
    end
  end

  context '#quote' do
    it 'returns the quote asset symbol' do
      expect(market.quote).to eq 'CNY'
    end
  end

  context '#base' do
    it 'returns the base asset symbol' do
      expect(market.base).to eq 'BTS'
    end
  end

  context '#center_price' do
    it 'returns the center price' do
      expect(market.center_price).to eq 0
    end
  end

  context '#last_fill' do
    it 'returns -1 if there is no order history' do
      allow(market).to receive(:order_hist).and_return []
      last_fill = market.last_fill
      expect(last_fill).to eq -1
    end

    it 'returns price of the last filled order' do
      last_fill = market.last_fill
      expect(last_fill > 0 && last_fill < 1).to be_truthy
    end
  end

  context '#lowest_ask' do
    it 'returns nil if there are no asks in the order book' do
      allow(market).to receive(:asks).and_return []
      expect(market.lowest_ask).to be_nil
    end

    it 'returns lowest ask price from order book' do
      ask_prices = market.send(:asks).map { |p| p['market_index']['order_price']['ratio'].to_f }.sort
      expect(market.lowest_ask).to eq ask_prices.first * MULTIPLIER
    end
  end

  context '#highest_bid' do
    it 'returns nil if there are no bids in the order book' do
      allow(market).to receive(:bids).and_return []
      expect(market.highest_bid).to be_nil
    end

    it 'returns highest bid price from order book' do
      bid_prices = market.send(:bids).map { |p| p['market_index']['order_price']['ratio'].to_f }.sort
      expect(market.highest_bid).to eq bid_prices.last * MULTIPLIER
    end
  end

  context '#mid_price' do
    it 'returns nil if either highest bid or lowest ask is nil' do
      allow(market).to receive(:highest_bid).and_return nil
      expect(market.mid_price).to be_nil
    end

    it 'returns the mid price' do
      mid = market.mid_price
      expect(mid > market.highest_bid && mid < market.lowest_ask).to be_truthy
    end
  end

end
