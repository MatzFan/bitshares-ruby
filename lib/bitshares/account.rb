module Bitshares

  class Account

    CLIENT = Bitshares::Client

    attr_reader :wallet, :name

    def initialize(wallet, name)
      @wallet = wallet
      @name = name
    end

    def method_missing(m, *args)
      CLIENT::rpc.request('wallet_account_' + m.to_s, [name] + args)
    end

  end

end
