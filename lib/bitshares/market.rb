module Bitshares

  class Market

    class AssetError < RuntimeError; end

    CHAIN = Bitshares::Blockchain
    SELL_ORDER_TYPES = %w(ask_order cover_order)
    BUY_ORDER_TYPES = %w(bid_order)

    attr_reader :quote, :base

    def initialize(quote_symbol, base_symbol)
      @quote_hash = get_asset quote_symbol.upcase
      @base_hash =  get_asset base_symbol.upcase
      @multiplier = multiplier
      @quote = @quote_hash['symbol']
      @base = @base_hash['symbol']
      @order_book = order_book
    end

    def center_price
      market_status['center_price']['ratio'].to_f
    end

    def last_fill
      return -1 if order_hist.empty?
      order_hist.first['bid_index']['order_price']['ratio'].to_f * multiplier
    end

    def mid_price
      return nil if highest_bid.nil? || lowest_ask.nil?
      (highest_bid + lowest_ask) / 2
    end

    def lowest_ask
      return if asks.empty?
      price asks.first
    end

    def highest_bid
      return if bids.empty?
      price bids.first
    end

    private

    def get_asset(s)
      CHAIN.get_asset(s) || (raise AssetError, "No such asset: #{s}")
    end

    def market_status
      CHAIN.market_status(@quote, @base)
    end

    def order_book
      CHAIN.market_order_book(@quote, @base)
    end

    def order_hist
      CHAIN.market_order_history(@quote, @base)
    end

    def multiplier
      @base_hash['precision'].to_f / @quote_hash['precision']
    end

    def check_new_order_type(order_list, order_types)
      new_ = order_list.reject { |p| order_types.any? { |t| p['type'] == t } }
      raise AssetError, "New order type: #{new_.first}" unless new_.empty?
      order_list
    end

    def buy_orders
      bids = @order_book.first
      check_new_order_type(bids, BUY_ORDER_TYPES)
    end

    def bids
      buy_orders.select { |p| p['type'] == 'bid_order' }
    end

    def sell_orders # includes 'ask_type' and 'cover_type'
      asks = @order_book.last
      check_new_order_type(asks, SELL_ORDER_TYPES)
    end

    def asks
      sell_orders.select { |p| p['type'] == 'ask_order' }
    end

    def covers
      sell_orders.select { |p| p['type'] == 'cover_order' }
    end

    def price(order) # CARE: preserve float precision with * NOT /
      order['market_index']['order_price']['ratio'].to_f * @multiplier
    end

  end

end
