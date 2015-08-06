require 'spec_helper'

abort 'bitshares client not running!' if `pgrep bitshares_clien`.empty? # 15 ch

describe Bitshares::Client do

  let(:client) { Bitshares::Client.new }

  context '#new' do
    it 'raises Bitshares::Client::Err "Server not running!" if the server isn\'t running' do
      allow(client).to receive(:rpc_ports).and_return []
      expect(->{client.send :bitshares_running?}).to raise_error Bitshares::Client::Err, 'Server not running!'
    end

    it 'instantiates an instance of the class if the bitshares server is running' do
      expect(client.class).to eq Bitshares::Client
    end
  end

  context 'valid client commands' do
    it 'with invalid username raise Bitshares::Client::Err "Bad credentials"' do
      stub_const('ENV', ENV.to_hash.merge('BITSHARES_USER' => 'wrong_password'))
      expect(->{client.get_info}).to raise_error Bitshares::Client::Err, 'Bad credentials'
    end

    it 'with invalid password raise Bitshares::Client::Err "Bad credentials"' do
      stub_const('ENV', ENV.to_hash.merge('BITSHARES_PWD' => 'wrong_password'))
      expect(->{client.get_info}).to raise_error Bitshares::Client::Err, 'Bad credentials'
    end

    it 'with valid credentials returns a Hash of returned JSON data' do
      expect(client.get_info.class).to eq Hash
    end
  end

  context 'invalid client commands' do
    it 'raise Bitshares::Client::Err' do
      expect(->{client.not_a_cmd}).to raise_error Bitshares::Client::Err
    end
  end

end
