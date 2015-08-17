require 'spec_helper'

describe Bitshares::Market do

  before { CLIENT.init }

  let(:cny_bts) { Bitshares::Market.new('CNY', 'BTS') }
  let(:invalid_market) { Bitshares::Market.new('BTS', 'CNY') } # quote ID = 0, base ID = 14

  MULTIPLIER = 10 # for this asset pair

  context '#new(quote, base)' do
    it 'raises Bitshares::Market::Error "Invalid asset <symbol>" if an invalid asset symbol is used' do
      expect(->{Bitshares::Market.new('BTC', 'GARBAGE')}).to raise_error Bitshares::Market::Error, 'Invalid asset: GARBAGE'
    end

    it 'raises Bitshares::Market::Error "Invalid market; quote ID <= base ID" if it is' do
      expect(->{invalid_market}).to raise_error Bitshares::Market::Error, 'Invalid market; quote ID <= base ID'
    end

    it 'instantiates an instance of the class with valid asset symbols (case insensitive)' do
      expect(Bitshares::Market.new('BTC', 'btS').class).to eq Bitshares::Market
    end
  end

  context '#quote' do
    it 'returns the quote asset symbol' do
      expect(cny_bts.quote).to eq 'CNY'
    end
  end

  context '#base' do
    it 'returns the base asset symbol' do
      expect(cny_bts.base).to eq 'BTS'
    end
  end

  context '#last_fill' do
    it 'returns -1 if there is no order history' do
      allow(cny_bts).to receive(:order_hist).and_return []
      last_fill = cny_bts.last_fill
      expect(last_fill).to eq -1
    end

    it 'returns price of the last filled order' do
      last_fill = cny_bts.last_fill
      expect(last_fill > 0 && last_fill < 1).to be_truthy
    end
  end

  context '#lowest_ask' do
    it 'returns nil if there are no asks in the order book' do
      allow(cny_bts).to receive(:asks).and_return []
      expect(cny_bts.lowest_ask).to be_nil
    end

    it 'returns lowest ask price from order book' do
      ask_prices = cny_bts.send(:asks).map { |p| p['market_index']['order_price']['ratio'].to_f }.sort
      expect(cny_bts.lowest_ask).to eq ask_prices.first * MULTIPLIER
    end
  end

  context '#highest_bid' do
    it 'returns nil if there are no bids in the order book' do
      allow(cny_bts).to receive(:bids).and_return []
      expect(cny_bts.highest_bid).to be_nil
    end

    it 'returns highest bid price from order book' do
      bid_prices = cny_bts.send(:bids).map { |p| p['market_index']['order_price']['ratio'].to_f }.sort
      expect(cny_bts.highest_bid).to eq bid_prices.last * MULTIPLIER
    end
  end

  context '#mid_price' do
    it 'returns nil if either highest bid or lowest ask is nil' do
      allow(cny_bts).to receive(:highest_bid).and_return nil
      expect(cny_bts.mid_price).to be_nil
    end

    it 'returns the mid price' do
      mid = cny_bts.mid_price
      expect(mid > cny_bts.highest_bid && mid < cny_bts.lowest_ask).to be_truthy
    end
  end

  context '#list_shorts' do
    it 'returns the list of shorts' do
      expect(cny_bts.list_shorts.all? { |o| o['type'] == 'short_order' }).to eq true
    end
  end

  context '#list_shorts' do
    it 'returns the list of shorts' do
      expect(cny_bts.get_asset_collateral).to be_kind_of Fixnum
    end
  end

end
