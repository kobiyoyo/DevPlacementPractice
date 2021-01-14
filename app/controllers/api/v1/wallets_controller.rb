class Api::V1::WalletsController < ApplicationController
  before_action :set_wallet, only: [:show, :update, :destroy]
  before_action :authorize_admin,only: [:destroy,:update]
  before_action :authorize_elite_or_noob,only: [:index,:show,:create]
  
  # GET /wallets
  def index
    @wallets = @current_user.wallets.all
    render json: @wallets
  end

  # GET /wallets/1
  def show
    render json: @wallet
  end

  # POST /wallets
  def create
    @wallet =  @current_user.wallets.build(wallet_params)

    if @wallet.save
      render json: @wallet, status: :created
    else
      render json: @wallet.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /wallets/1
  def update
    if @wallet.update(wallet_params)
      render json: @wallet
    else
      render json: @wallet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /wallets/1
  def destroy
    @wallet.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wallet
      @wallet = Wallet.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def wallet_params
      params.permit(:amount, :main, :user_id, :currency_id)
    end
end
