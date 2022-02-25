require 'rails_helper'

RSpec.describe 'PurchaseOrderCreator' do
  describe '#call' do
    let(:cart) { create(:cart) }
    let(:user) { cart.user }
    let(:address) { nil }
    let(:sale) { create(:sale, name: 'Sales free', unit_price_cents: 10) }
    let!(:cart_item) { create(:cart_item, cart: cart, sale: sale, quantity: 2) }

    it 'creates order' do
      expect do
        PurchaseOrderCreator.call({ user: user, cart: cart, address: address })
      end.to change { Order.count }
    end

    it 'creates  a new order object with proper params' do
      expect(
        PurchaseOrderCreator.call({ user: user, cart: cart, address: address })
      ).to have_attributes({
                             user: user,
                             first_name: user.first_name,
                             last_name: user.last_name,
                             address_1: nil,
                             address_2: nil,
                             city: nil,
                             state: nil,
                             country: nil,
                             zip: nil
                           })
    end

    it 'creates order line items' do
      expect do
        PurchaseOrderCreator.call({ user: user, cart: cart, address: address })
      end.to change { OrderLineItem.count }.by(2)
    end

    it 'creates  new order lines object with proper params' do
      PurchaseOrderCreator.call({ user: user, cart: cart, address: address })
      expect(
        OrderLineItem.pluck(:unit_price_cents, :shipping_costs_cents, :taxes_cents, :paid_price_cents)
      ).to eq([[10, 100, 0, 110], [10, 100, 0, 110]])
    end
  end
end
