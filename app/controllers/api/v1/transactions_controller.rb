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
      if @transaction_params.transaction_type == "deposit"
        deposit(@transaction_params)
      elsif @transaction_params.transaction_type == "withdraw"
        withdraw(@transaction_params)
      end
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

    #Add amount to wallet
    def add_to_wallet(user_id,wallet_id,amount)
        wallet = Wallet.find_by(user_id: user_id,id: wallet_id)
        wallet.increment(:amount,amount)
        wallet.save
    end

    #Reduce amount to wallet
    def deduct_from_wallet(user_id,wallet_id,amount)
        wallet = Wallet.find_by(user_id: user_id,id: wallet_id)
        wallet.decrement(:amount,amount)
        wallet.save
    end

    #Withdraw funds from wallet
    def withdraw(transaction_params)
      if @current_user.admin?
      response = { message: 'Unauthorised: Only Noobs and Elite users can withdraw!'}
      render json: response
      else
        transaction_params.user_id = @current_user.id
        transaction_params.status = "successful"
        deduct_from_wallet(transaction_params.user_id,transaction_params.wallet_id,transaction_params.amount)
      end
    end

    #deposit funds to wallet
    def deposit(transaction_params)
        if @current_user.admin?
          transaction_params.status = "successful"
          add_to_wallet(transaction_params.user_id,transaction_params.wallet_id,transaction_params.amount)
          check_status(transaction_params)
        elsif @current_user.noob?
          transaction_params.user_id = @current_user.id
          transaction_params.confirm = false
          transaction_params.status = "pending"
          response = { message: 'Deposit has been sent for approval'}
          render json: response
          transaction_params.save
        else
          transaction_params.user_id = @current_user.id
          transaction_params.confirm = true
          transaction_params.status = "successful"
          add_to_wallet(@current_user.id,transaction_params.wallet_id,transaction_params.amount)
          check_status(transaction_params)
        end
    end
end
