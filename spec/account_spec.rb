require 'spec_helper'

describe Bitshares::Account do

  let(:wallet) { double Bitshares::Wallet }
  let(:account) { Bitshares::Account.new(wallet, 'account_name') }

  context '#wallet' do
    it 'references an instance of Bitshares::Wallet class' do
      expect(account.wallet).to eq wallet
    end
  end

  context '#name' do
    it 'references the account name' do
      expect(account.name).to eq 'account_name'
    end
  end

  context '#method_missing' do
    it 'sends it\'s @wallet instance the method appended with "account_"' do
      allow(wallet).to receive(:account_balance) {}
      expect(->{account.balance}).not_to raise_error
    end
  end

end
