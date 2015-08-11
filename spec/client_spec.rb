require 'spec_helper'

abort 'bitshares client not running!' if `pgrep bitshares_clien`.empty? # 15 ch

describe Bitshares::Client do

  let(:client) { Bitshares::Client }

  context '#new' do
    it 'raises Bitshares::Client::Rpc::Err "Server not running!" if the server isn\'t running' do
      Bitshares::Client.init
      allow(client.rpc).to receive(:rpc_ports).and_return []
      expect(->{client.rpc.send :bitshares_running?}).to raise_error Bitshares::Client::Rpc::Err, 'Server not running!'
    end
  end

  context '#rpc_request' do
    it 'with invalid username raise Bitshares::Client::Rpc::Err "Bad credentials"' do
      stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => 'wrong_password'))
      Bitshares::Client.init
      expect(->{client.get_info}).to raise_error Bitshares::Client::Rpc::Err, 'Bad credentials'
    end

    it 'with invalid password raise Bitshares::Client::Rpc::Err "Bad credentials"' do
      stub_const('ENV', ENV.to_hash.merge('BITSHARES_PASSWORD' => 'wrong_password'))
      Bitshares::Client.init
      expect(->{client.get_info}).to raise_error Bitshares::Client::Rpc::Err, 'Bad credentials'
    end

    it 'with valid credentials and invalid client command raises Bitshares::Client::Rpc::Err' do
      Bitshares::Client.init
      expect(->{client.not_a_cmd}).to raise_error Bitshares::Client::Rpc::Err
    end

    it 'with valid credentials and valid client command returns a Hash of returned JSON data' do
      Bitshares::Client.init
      expect(client.get_info.class).to eq Hash
    end
  end

end
