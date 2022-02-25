require 'rails_helper'

RSpec.describe 'PurchaseOrderCreator' do
  describe '#call' do
    let(:cart) { create(:cart) }
    let(:sale) { create(:sale, name: 'Sales free', unit_price_cents: 10) }
    let!(:cart_item) { create(:cart_item, cart: cart, sale: sale, quantity: 2) }
    subject(:order) { PurchaseOrderCreator.call({ user: cart.user, cart: cart, address: nil }) }

    it 'creates a new order object with proper params' do
      expect(
        order
      ).to have_attributes({
                             user: cart.user,
                             first_name: cart.user.first_name,
                             last_name: cart.user.last_name,
                             address_1: nil,
                             address_2: nil,
                             city: nil,
                             state: nil,
                             country: nil,
                             zip: nil
                           }).and eq(Order.first)
    end

    it 'creates new order lines object with proper params' do
      expect(
        OrderLineItem.all
      ).to match_array([
                         have_attributes({ unit_price_cents: 10, shipping_costs_cents: 100, taxes_cents: 0,
                                           paid_price_cents: 110 }),
                         have_attributes({ unit_price_cents: 10, shipping_costs_cents: 100, taxes_cents: 0,
                                           paid_price_cents: 110 })
                       ]).and eq(order.items)
    end
  end
end
