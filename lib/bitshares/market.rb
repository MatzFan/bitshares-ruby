module Bitshares

  class Market

    class Error < RuntimeError; end

    attr_reader :quote, :base

    def initialize(quote, base)
      [quote, base].each &:upcase!
      @quote_hash, @base_hash = asset(quote), asset(base)
      @quote, @base = @quote_hash['symbol'], @base_hash['symbol']
      valid_market?(@quote_hash['id'], @base_hash['id'])
      @multiplier = multiplier
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

    def list_shorts(limit = nil) # uses quote only, not base
      CLIENT.request('blockchain_market_list_shorts', [quote] + [limit])
    end

    def get_asset_collateral # uses quote only, not base
      CLIENT.request('blockchain_market_get_asset_collateral', [quote])
    end

    def method_missing(m, *args)
      CLIENT.request('blockchain_market_' + m.to_s, [quote, base] + args)
    end

    private

    def asset(symbol) # returns hash
      CHAIN.get_asset(symbol) || (raise Error, "Invalid asset: #{symbol}")
    end

    def valid_market?(quote_id, base_id)
      raise Error, 'Invalid market; quote ID <= base ID' if quote_id <= base_id
    end

    def order_hist
      self.order_history
    end

    def multiplier
      @base_hash['precision'].to_f / @quote_hash['precision']
    end

    def bids
      self.list_bids
    end

    def asks
      self.list_asks
    end

    def price(order) # CARE: preserve float precision with * NOT /
      order['market_index']['order_price']['ratio'].to_f * @multiplier
    end

  end

end
