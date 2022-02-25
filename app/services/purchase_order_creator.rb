class PurchaseOrderCreator < ApplicationService
  SHIPPING_COSTS = 100
  
  def initialize(purchase_params)
    @address_params = purchase_params[:address] || {}
    @cart = purchase_params[:cart]
    @user = purchase_params[:user]
  end

  def call
    order = Order.new(
      user: @user,
      first_name: @user.first_name,
      last_name: @user.last_name,
      address_1: @address_params[:address_1],
      address_2: @address_params[:address_2],
      city: @address_params[:city],
      state: @address_params[:state],
      country: @address_params[:country],
      zip: @address_params[:zip]
    )
    order.items = get_cart_items(order)
    order.save
    order
  end

  private
  
  def get_cart_items(order)
    @cart.items.flat_map do |item|
      item.quantity.times.map do
        OrderLineItem.new(
          order: order,
          sale: item.sale,
          unit_price_cents: item.sale.unit_price_cents,
          shipping_costs_cents: SHIPPING_COSTS,
          paid_price_cents: item.sale.unit_price_cents + SHIPPING_COSTS
        )
      end
    end    
  end

end
