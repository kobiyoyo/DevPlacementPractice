class Api::V1::TransactionsController < ApplicationController
  before_action :set_transaction, only: [:show, :update, :destroy]

  # GET /transactions
  def index
    @transactions = Transaction.all

    render json: @transactions
  end

  # GET /transactions/1
  def show
    render json: @transaction
  end

  # POST /transactions
  def create
    @transaction_params = Transaction.new(transaction_params)
    @transaction_action = TransactionAction.new
    render json: @transaction_action.action(@transaction_params,@current_user)
  end

  # PATCH/PUT /transactions/1
  def update
    if @transaction.update(transaction_params)
      render json: @transaction
    else
      render json: @transaction.errors, status: :unprocessable_entity
    end
  end

  # DELETE /transactions/1
  def destroy
    @transaction.destroy
  end

  def check_status(transaction)
     if transaction.save
       render json: transaction, status: :created
     else
       render json: transaction.errors, status: :unprocessable_entity
     end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def transaction_params
      params.permit(:transaction_type, :description, :amount, :status, :confirm, :user_id, :wallet_id)
    end
end
