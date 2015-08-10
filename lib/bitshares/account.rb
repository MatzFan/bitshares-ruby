module Bitshares

  class Account

    attr_reader :wallet, :name

    def initialize(wallet, name)
      @wallet = wallet
      @name = name
    end

    def method_missing(name, *args)
      Bitshares::Client::rpc.request('wallet_account_' + name.to_s, args)
    end

  end

end
