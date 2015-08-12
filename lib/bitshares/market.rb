module Bitshares

  class Market

    class AssetError < RuntimeError; end

    CHAIN = Bitshares::Blockchain

    attr_reader :quote, :base

    def initialize(quote, base)
      [quote, base].each &:upcase!
      @quote_hash, @base_hash = asset(quote), asset(base)
      @quote, @base = @quote_hash['symbol'], @base_hash['symbol']
      @multiplier = multiplier
    end

    def center_price
      self.status(@quote, @base)['center_price']['ratio'].to_f
    end

    def last_fill
      return -1 if order_hist.empty?
      order_hist.first['bid_index']['order_price']['ratio'].to_f * multiplier
    end

    def lowest_ask
      return if asks.empty?
      price asks.first
    end

    def highest_bid
      return if bids.empty?
      price bids.first
    end

    def mid_price
      return nil if highest_bid.nil? || lowest_ask.nil?
      (highest_bid + lowest_ask) / 2
    end

    def method_missing(name, *args)
      Bitshares::Client::rpc.request('blockchain_market_' + name.to_s, args)
    end

    private

    def asset(symbol) # returns hash
      CHAIN.get_asset(symbol) || (raise AssetError, "Invalid asset: #{symbol}")
    end

    def order_hist
      self.order_history(@quote, @base)
    end

    def multiplier
      @base_hash['precision'].to_f / @quote_hash['precision']
    end

    def bids
      self.list_bids(@quote, @base)
    end

    def asks
      self.list_asks(@quote, @base)
    end

    def price(order) # CARE: preserve float precision with * NOT /
      order['market_index']['order_price']['ratio'].to_f * @multiplier
    end

  end

end
