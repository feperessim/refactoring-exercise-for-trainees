class PurchaseOrderCreator < ApplicationService
  def initialize(purchase_params)
    @address = purchase_params[:address]
    @cart = purchase_params[:cart]
    @user = purchase_params[:user]
  end

  def call
    create
  end
  
  private_class_method :new

  def create
    order = Order.new(
      user: @user,
      first_name: @user.first_name,
      last_name: @user.last_name,
      address_1: address_params[:address_1],
      address_2: address_params[:address_2],
      city: address_params[:city],
      state: address_params[:state],
      country: address_params[:country],
      zip: address_params[:zip],
    )

    order.items = @cart.items.flat_map do |item|
      item.quantity.times.map do
        OrderLineItem.new(
          order: order,
          sale: item.sale,
          unit_price_cents: item.sale.unit_price_cents,
          shipping_costs_cents: shipping_costs,
          paid_price_cents: item.sale.unit_price_cents + shipping_costs
        )
      end
    end

    order.save
    order
  end

  def address_params
    @address || {}
  end
  
  def shipping_costs
    100
  end
  
end
