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

  context '#wallet' do
    Bitshares::Client.init
    it 'records the currently open wallet - nil when first instantiated' do
      expect(Bitshares::Client.wallet).to be_nil
    end
  end

  context '#open' do

    before { Bitshares::Client.init }

    it 'opens the wallet with the provided name' do
      client.wallet_close
      expect(client.wallet_get_info['open']).to eq false
      client.open 'test1'
      expect(client.wallet_get_info['name']).to eq 'test1'
      expect(client.wallet_get_info['open']).to eq true
    end

    it 'sets wallet to an instance of Bitshares::Wallet class' do
      client.open 'test1'
      expect(client.wallet.class).to eq Bitshares::Wallet
    end
  end

  context '#close' do

    before { Bitshares::Client.init }

    it 'closes the wallet' do
      client.wallet_open 'test1'
      expect(client.wallet_get_info['open']).to eq true
      client.close
      expect(client.wallet_get_info['name']).to eq nil
      expect(client.wallet_get_info['open']).to eq false
    end

    it 'sets wallet to nil' do
      client.close
      expect(client.wallet).to be_nil
    end
  end

  context '#rpc_request' do
    it 'with invalid username raise Bitshares::Client::Rpc::Err "Bad credentials"' do
      stub_const('ENV', ENV.to_hash.merge('BITSHARES_USER' => 'wrong_password'))
      Bitshares::Client.init
      expect(->{client.get_info}).to raise_error Bitshares::Client::Rpc::Err, 'Bad credentials'
    end

    it 'with invalid password raise Bitshares::Client::Rpc::Err "Bad credentials"' do
      stub_const('ENV', ENV.to_hash.merge('BITSHARES_PWD' => 'wrong_password'))
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
