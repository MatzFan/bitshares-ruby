module Bitshares

  class Wallet

    attr_reader :name, :account

    def initialize(name)
      @name = name
      @account = nil
      @password = Bitshares.config[:wallet][@name]
    end

    def account(name)
      @account = Bitshares::Account.new(self, name)
    end

    def open
      CLIENT.request('wallet_open', [@name])
    end

    def lock
      open # must be opened first
      CLIENT.request 'wallet_lock'
    end

    def unlock(timeout = 1776)
      open # must be opened first
      CLIENT.request('wallet_unlock', [timeout, @password])
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
      CLIENT.request('wallet_' + m.to_s, args)
    end

  end

end
