module Bitshares

  class Blockchain

    def self.method_missing(name, *args)
      CLIENT.request('blockchain_' + name.to_s, args)
    end

  end

end
