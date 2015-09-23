class OrdersController < ApplicationController

  protect_from_forgery except: :notify

  def index
    @orders = current_user.orders
  end

  def new
    @order = current_user.orders.build

    @order.email = current_user.email
    @order.name = current_user.name
  end

  def create
    @order = current_user.orders.build( order_params )
    @order.payment_method = "Credit"

    if @order.save
      redirect_to checkout_allpay_order_path(@order)
    else
      render :new
    end
  end

  def checkout_allpay
    @order = current_user.orders.find( params[:id] )

      @payment = Payment.create!( :order_id => @order.id,
                                  :payment_method => "Credit" )
      # render :layout => false

  end

  def notify


    @payment = Payment.find_and_process(params)
    @payment.save

    render text: '1|OK', status: 200
  end

  protected

  def order_params
    params.require(:order).permit(:name, :email, :phone, :address, :amount)
  end

end
