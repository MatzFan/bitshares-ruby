module Bitshares

  class Trader

    class Error < RuntimeError; end

    WMSA = 'wallet_market_submit_ask'
    WMSB = 'wallet_market_submit_bid'
    WMOL = 'wallet_market_order_list'
    WMCO = 'wallet_market_cancel_orders'

    attr_reader :account, :market

    def initialize(account, market)
      @account = account
      @wallet = account.wallet
      @name = account.name
      @market = market
      @base = market.base
      @quote = market.quote
    end

    def submit_ask(quantity, price, stupid = false)
      @wallet.unlock if @wallet.locked?
      o = CLIENT.request(WMSA, [@name, quantity, @base, price, @quote, stupid])
      o['record_id'] # return order id
    end

    def submit_bid(quantity, price, stupid = false)
      @wallet.unlock if @wallet.locked?
      o = CLIENT.request(WMSB, [@name, quantity, @base, price, @quote, stupid])
      o['record_id'] # return order id
    end

    def order_list(limit = '-1')
      CLIENT.request(WMOL, [@quote, @base, limit, @name])
    end

    def cancel_orders(*id_list)
      @wallet.unlock if @wallet.locked?
      confirm = CLIENT.request(WMCO, id_list)
      confirm['ledger_entries'].map { |e| e['memo'] } # returns 'cancel ASK-xxxxxxxx' first 8 chars of order id
    end

    def cancel_all
      cancel_orders all_order_ids
    end

    private

    def all_order_ids
      order_list.map &:first
    end

  end

end
