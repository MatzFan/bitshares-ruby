module Bitshares

  class Wallet

    attr_reader :name, :account

    def initialize(name)
      @name = name
      @account = nil
      @password = Bitshares.config[:wallets][@name.to_sym]
    end

    def account(name)
      @account = Bitshares::Account.new(self, name)
    end

    def open
      Bitshares::Client::rpc.request('wallet_open', [@name])
    end

    def lock
      open # must be opened first
      Bitshares::Client::rpc.request 'wallet_lock'
    end

    def unlock(timeout = 1776)
      open # must be opened first
      Bitshares::Client::rpc.request('wallet_unlock', [timeout, @password])
    end

    def open?
      self.get_info['open']
    end

    def closed?
      !open?
    end

    def unlocked?
      open
      get_info['unlocked']
    end

    def locked?
      !unlocked?
    end

    def method_missing(m, *args)
      Bitshares::Client::rpc.request('wallet_' + m.to_s, args)
    end

  end

end
