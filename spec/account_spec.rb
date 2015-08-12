require 'spec_helper'

describe Bitshares::Account do

  before { Bitshares::Client.init }

  let(:wallet) { Bitshares::Wallet.new 'test1' }
  let(:account) { Bitshares::Account.new(wallet, 'account-test') }

  context '#wallet' do
    it 'references an instance of Bitshares::Wallet class' do
      expect(account.wallet).to eq wallet
    end
  end

  context '#name' do
    it 'references the account name' do
      expect(account.name).to eq 'account-test'
    end
  end

  context '#method_missing' do
    it 'sends client the method appended with "wallet_account_"' do
      expect(account.list_public_keys.first['native_pubkey']).to include 'BTS'
    end

    it 'sends client the method appended with "wallet_account_" and any params' do
      begin
        account.rename('account-test')
      rescue Bitshares::Client::Rpc::Err => e
        expect(e.to_s).to include 'duplicate account name'
      end
    end
  end

end
