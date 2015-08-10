require 'spec_helper'

describe Bitshares::Wallet do

  before { Bitshares::Client.init }

  let(:rpc) { instance_double Bitshares::Client::Rpc }
  let(:wallet) { Bitshares::Wallet.new('wallet_name') }

  context '#name' do
    it 'references the wallet name' do
      expect(wallet.name).to eq 'wallet_name'
    end
  end

  context '#method_missing' do
    it 'sends the client the method appended with "wallet_"' do
      expect(wallet.list.class).to eq Array
    end
  end

end
