require 'spec_helper'

describe Bitshares::Wallet do

  let(:client) { double Bitshares::Client }
  let(:wallet) { Bitshares::Wallet.new(client, 'wallet_name') }

  context '#client' do
    it 'references an instance of Bitshares::Client class' do
      expect(wallet.client).to eq client
    end
  end

  context '#name' do
    it 'references the wallet name' do
      expect(wallet.name).to eq 'wallet_name'
    end
  end

  context '#method_missing' do
    it 'sends it\'s @client instance the method appended with "wallet_"' do
      allow(client).to receive(:wallet_list) {}
      expect(->{wallet.list}).not_to raise_error
    end
  end

end
