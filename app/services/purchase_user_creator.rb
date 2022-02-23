class PurchaseUserCreator < ApplicationService
  def initialize(purchase_params)
    @cart_user = purchase_params[:cart_user]
    @user_params = purchase_params[:user_params]
  end

  def call
    create
  end

  private_class_method :new

  def create
    @cart_user || User.create(**(@user_params || {}).merge(guest: true))
  end
end
