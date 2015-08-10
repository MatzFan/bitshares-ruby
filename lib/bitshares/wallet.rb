module Bitshares

  class Wallet

    attr_reader :name, :account

    def initialize(name)
      @name = name
      @account = nil
    end

    def account(name)
      @account = Bitshares::Account.new(self, name)
    end

    def method_missing(name, *args)
      puts name
      puts args
      Bitshares::Client::rpc.request('wallet_' + name.to_s, args)
    end

  end

end
