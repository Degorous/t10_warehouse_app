class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show, :edit, :update]

  def show; end

  def new
    @order = Order.new
    @warehouses = Warehouse.all
    @suppliers = Supplier.all
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user
    if @order.save
      redirect_to @order, notice: 'Pedido registrado com sucesso'
    else
      @warehouses = Warehouse.all
      @suppliers = Supplier.all
      flash.now[:notice] = 'Não foi possível registrar o pedido'
      render 'new'
    end
  end

  def search
    @code = params['query']

    @orders = Order.where("code LIKE ?", "%#{@code}%")
  end

  private
  
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:warehouse_id, :supplier_id, :estimated_delivery_date )
  end
end