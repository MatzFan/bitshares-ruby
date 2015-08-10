require 'spec_helper'

abort 'bitshares client not running!' if `pgrep bitshares_clien`.empty? # 15 ch

describe Bitshares::Client do

  let(:client) { Bitshares::Client.new }

  context '#new' do
    it 'raises Bitshares::Client::Err "Server not running!" if the server isn\'t running' do
      allow(client).to receive(:rpc_ports).and_return []
      expect(->{client.send :bitshares_running?}).to raise_error Bitshares::Client::Err, 'Server not running!'
    end
  end

  context '#wallet' do
    it 'records the currently open wallet - nil when first instantiated' do
      expect(client.wallet).to be_nil
    end
  end

  context '#open' do
    it 'opens the wallet with the provided name' do
      client.wallet_close
      expect(client.wallet_get_info['open']).to eq false
      client.open 'test1'
      expect(client.wallet_get_info['name']).to eq 'test1'
      expect(client.wallet_get_info['open']).to eq true
    end

    it 'sets @wallet to an instance of Bitshares::Wallet class' do
      client.open 'test1'
      expect(client.wallet.class).to eq Bitshares::Wallet
    end
  end

  context '#close' do
    it 'closes the wallet' do
      client.wallet_open 'test1'
      expect(client.wallet_get_info['open']).to eq true
      client.close
      expect(client.wallet_get_info['name']).to eq nil
      expect(client.wallet_get_info['open']).to eq false
    end

    it 'sets @wallet to nil' do
      client.close
      expect(client.wallet).to be_nil
    end
  end

  context '#rpc_request' do
    it 'with invalid username raise Bitshares::Client::Err "Bad credentials"' do
      stub_const('ENV', ENV.to_hash.merge('BITSHARES_USER' => 'wrong_password'))
      expect(->{client.get_info}).to raise_error Bitshares::Client::Err, 'Bad credentials'
    end

    it 'with invalid password raise Bitshares::Client::Err "Bad credentials"' do
      stub_const('ENV', ENV.to_hash.merge('BITSHARES_PWD' => 'wrong_password'))
      expect(->{client.get_info}).to raise_error Bitshares::Client::Err, 'Bad credentials'
    end

    it 'with valid credentials and invalid client command raises Bitshares::Client::Err' do
      expect(->{client.not_a_cmd}).to raise_error Bitshares::Client::Err
    end

    it 'with valid credentials and valid client command returns a Hash of returned JSON data' do
      expect(client.get_info.class).to eq Hash
    end
  end

end
