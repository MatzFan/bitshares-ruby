module Bitshares

  class Client

    attr_reader :wallet # the currently open wallet

    class Err < RuntimeError; end

    def initialize
      bitshares_running?
      @uri = URI("http://localhost:#{rpc_http_port}/rpc")
      @req = Net::HTTP::Post.new(@uri)
      @req.content_type = 'application/json'
      @req.basic_auth ENV['BITSHARES_USER'], ENV['BITSHARES_PWD']
      @wallet = nil
    end

    def rpc_request(m, args = [])
      resp = nil
      Net::HTTP.start(@uri.hostname, @uri.port) do |http|
        @req.body = { method: m, params: args, jsonrpc: '2.0', id: 0 }.to_json
        resp = http.request(@req)
      end
      raise Err, 'Bad credentials' if resp.class == Net::HTTPUnauthorized
      result = JSON.parse(resp.body)
      e = result['error']
      raise Err, JSON.pretty_generate(e), "#{m} #{args.join(' ') if args}" if e
      return result['result']
    end

    def method_missing(method, *args)
      rpc_request(method, args)
    end

    def open(name)
      self.wallet_open name
      @wallet = Bitshares::Wallet.new(self, name)
    end

    def close
      self.wallet_close
      @wallet = nil
    end

    private

    def bitshares_running?
      raise Err, 'Server not running!' unless rpc_ports.count == 2
    end

    def rpc_http_port
      rpc_ports.each do |port| # only http RPC port raises a non-empty response
        return port unless `curl -s -I -L http://localhost:#{port}`.empty?
      end
    end

    def rpc_ports # returns bitshares HTTP JSON RPC and JSON RPC server ports
      `lsof -iTCP@localhost | grep bitshares`.scan(/:(\d+) \(LISTEN\)/).flatten
    end

  end

end
