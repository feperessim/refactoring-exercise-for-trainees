require 'rails_helper'

RSpec.describe 'PurchaseOrderCreator' do
  describe '#call' do
    let(:cart) { create(:cart) }
    let(:user) { cart.user }
    let(:address) { nil }

    it 'creates order' do
      expect do
        PurchaseOrderCreator.call({ user: user, cart: cart, address: address })
      end.to change { Order.count }
    end

    it 'returns a new order object' do
      expect(
        PurchaseOrderCreator.call({ user: user, cart: cart, address: address })
      ).to eq(Order.first)
    end
  end
end
