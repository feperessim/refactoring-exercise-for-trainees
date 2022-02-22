class PurchasesController < ApplicationController
  def create
    return render json: { errors: [{ message: 'Gateway not supported!' }] },
                  status: :unprocessable_entity unless ['paypal', 'stripe'].include? purchase_params[:gateway]

    return render json: { errors: [{ message: 'Cart not found!' }] },
                  status: :unprocessable_entity unless cart = Cart.find_by(id: purchase_params[:cart_id])
   
    user = PurchaseUserCreator.call({ cart_user: cart.user, user: purchase_params[:user] })
                                                                                            
    return render json: { errors: user.errors.map(&:full_message).map { |message| { message: message } } },
                  status: :unprocessable_entity unless  user && user.valid?
    
    return render json: { status: :success, order: { id: order.id } },
                  status: :ok unless order = PurchaseOrderCreator.call({ cart: cart, user: user, address: purchase_params[:address] }) 
    
    render json: { errors: order.errors.map(&:full_message).map { |message| { message: message } } }, status: :unprocessable_entity
    
  end

  private

  def purchase_params
    params.permit(
      :gateway,
      :cart_id,
      user: %i[email first_name last_name],
      address: %i[address_1 address_2 city state country zip]
    )
  end
end
