module Bitshares

  class Wallet

    attr_reader :client, :name, :account

    def initialize(client, name)
      @client = client
      @name = name
      @account = nil
    end

    def account(name)
      @account = Bitshares::Account.new(self, name)
    end

    def method_missing(name, *args)
      @client.send ('wallet_' + name.to_s).to_sym, args
    end

  end

end
