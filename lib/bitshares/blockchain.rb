module Bitshares

  class Blockchain

    def self.method_missing(name, *args)
      Bitshares::Client::rpc.request('blockchain_' + name.to_s, args)
    end

  end

end
