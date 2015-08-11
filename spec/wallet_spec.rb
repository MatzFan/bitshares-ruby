require 'spec_helper'

describe Bitshares::Wallet do

  before { Bitshares::Client.init }

  let(:rpc) { instance_double Bitshares::Client::Rpc }
  let(:wallet) { Bitshares::Wallet.new('test1') }

  context '#new(name)' do
    it 'raises a Bitshares::Client::Rpc::Err error with an invalid wallet name' do
      expect(->{wallet.new 'duff_name'}).to raise_error Bitshares::Client::Rpc::Err
    end
  end

  context '#name' do
    it 'returns the wallet name' do
      expect(wallet.name).to eq 'test1'
    end
  end

  context '#open' do
    it 'opens the wallet' do
      wallet.close
      wallet.open
      expect(wallet.get_info['open']).to eq true
    end
  end

  context '#open?' do
    it 'is the wallet open?' do
      wallet.close
      expect(wallet.open?).to eq false
    end
  end

  context '#closed?' do
    it 'is the wallet closed?' do
      wallet.close
      expect(wallet.closed?).to eq true
    end
  end

  context '#lock' do
    it 'locks the wallet' do
      wallet.lock
      expect(wallet.locked?).to eq true
    end
  end

  context '#unlock([timeout])' do
    it 'with no args unlocks the wallet with default timeout' do
      wallet.unlock
      expect(wallet.unlocked?).to eq true
    end

    it 'unlocks the wallet with timeout set (in seconds) if provided' do
      wallet.lock
      wallet.unlock(1)
      sleep 1
      expect(wallet.locked?).to eq true
    end
  end

  context '#unlocked?' do
    it 'is the wallet unlocked?' do
      wallet.lock
      expect(wallet.unlocked?).to eq false
    end
  end

  context '#locked?' do
    it 'is the wallet locked?' do
      wallet.lock
      expect(wallet.locked?).to eq true
    end
  end

  context '#method_missing' do
    it 'sends the client the method appended with "wallet_" and any args' do
      wallet.set_setting('to_delete', 'yes')
      expect(wallet.get_setting('to_delete')['value']).to eq 'yes'
    end
  end

end
