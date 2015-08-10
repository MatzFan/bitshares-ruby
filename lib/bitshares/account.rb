module Bitshares

  class Account

    attr_reader :wallet, :name

    def initialize(wallet, name)
      @wallet = wallet
      @name = name
    end

    def method_missing(name, *args)
      @wallet.send ('account_' + name.to_s).to_sym, args
    end

  end

end
