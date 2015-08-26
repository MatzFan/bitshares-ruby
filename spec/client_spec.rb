require 'spec_helper'

describe Bitshares::Client do

  before do
    Bitshares.configure(:rpc_username => ENV['BITSHARES_ACCOUNT']) # must be set to valid account
    Bitshares.configure(:rpc_password => ENV['BITSHARES_PASSWORD']) # must be set to valid password
  end

  let(:client) { CLIENT }

  context '#new' do
    it 'raises Bitshares::Client::Rpc::Err "Server not running!" if the server isn\'t running' do
      Bitshares::Client.init
      allow(client).to receive(:rpc_ports).and_return []
      expect(->{client.send :bitshares_running?}).to raise_error Bitshares::Client::Err, 'Server not running!'
    end
  end

  context '#synced?' do
    it 'returns false if the client is not synced with the network' do
      c = client
      head = c.get_info['blockchain_head_block_num']
      allow(c).to receive(:blockchain_get_block_count).and_return(head -1)
      expect(c.synced?).to be false
    end

    it 'returns true if the client is synced with the network' do
      c = client
      head = c.get_info['blockchain_head_block_num']
      allow(c).to receive(:blockchain_get_block_count).and_return head
      expect(c.synced?).to be true
    end
  end

  context '#rpc_request' do
    context 'using ENV credentials' do
      it 'with invalid username raises Bitshares::Client::Err "Bad credentials"' do
        stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => 'wrong_username', 'BITSHARES_PASSWORD' => 'password1'))
        CLIENT.init
        expect(->{client.get_info}).to raise_error Bitshares::Client::Err, 'Bad credentials'
      end

      it 'with invalid password raises Bitshares::Client::Err "Bad credentials"' do
        stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => 'test1', 'BITSHARES_PASSWORD' => 'wrong_password'))
        CLIENT.init
        expect(->{client.get_info}).to raise_error Bitshares::Client::Err, 'Bad credentials'
      end

      it 'with valid credentials and invalid client command raises Bitshares::Client::Err' do
        CLIENT.init
        expect(->{client.not_a_cmd}).to raise_error Bitshares::Client::Err
      end

      it 'with valid credentials and valid client command returns a Hash of returned JSON data' do
        CLIENT.init
        expect(client.get_info.class).to eq Hash
      end
    end

    context 'using config credentials' do

      it 'with invalid username raises Bitshares::Client::Err "Bad credentials"' do
        Bitshares.configure(:rpc_username => 'wrong_username')
        stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => nil))
        stub_const('ENV', ENV.to_hash.merge('BITSHARES_PASSWORD' => nil))
        CLIENT.init
        expect(->{client.get_info}).to raise_error Bitshares::Client::Err, 'Bad credentials'
      end

      it 'with invalid password raises Bitshares::Client::Err "Bad credentials"' do
        Bitshares.configure(:rpc_password => 'wrong_password')
        stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => nil))
        stub_const('ENV', ENV.to_hash.merge('BITSHARES_PASSWORD' => nil))
        CLIENT.init
        expect(->{client.get_info}).to raise_error Bitshares::Client::Err, 'Bad credentials'
      end

      it 'with valid credentials and invalid client command raises Bitshares::Client::Err' do
        stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => nil))
        stub_const('ENV', ENV.to_hash.merge('BITSHARES_PASSWORD' => nil))
        CLIENT.init
        expect(->{client.not_a_cmd}).to raise_error Bitshares::Client::Err
      end

      it 'with valid credentials and valid client command returns a Hash of returned JSON data' do
        stub_const('ENV', ENV.to_hash.merge('BITSHARES_ACCOUNT' => nil))
        stub_const('ENV', ENV.to_hash.merge('BITSHARES_PASSWORD' => nil))
        CLIENT.init
        expect(client.get_info.class).to eq Hash
      end

    end
  end

end
