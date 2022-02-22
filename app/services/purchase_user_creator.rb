class PurchaseUserCreator < ApplicationService
  def initialize(purchase_params)
    @cart_user = purchase_params[:cart_user]
    @user = purchase_params[:user]
  end

  def call
    create
  end
  
  private_class_method :new

  def create
    @cart_user || User.create(**(@user ? @user : {}), guest: true)
  end
  
end
