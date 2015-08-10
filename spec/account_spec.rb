require 'spec_helper'

describe Bitshares::Account do

  before { Bitshares::Client.init }

  let(:wallet) { Bitshares::Client.open 'test1' }
  let(:account) { Bitshares::Account.new(wallet, 'duff_account_name') }

  context '#wallet' do
    it 'references an instance of Bitshares::Wallet class' do
      expect(account.wallet).to eq wallet
    end
  end

  context '#name' do
    it 'references the account name' do
      expect(account.name).to eq 'duff_account_name'
    end
  end

  context '#method_missing' do
    it 'sends client the method appended with "wallet_account_" and any params' do
      expect(account.historic_balance '2015-08-10T20:11:10').to eq []
    end
  end

end
