class TransactionAction
  require "faraday"
  require "json"

  def currency_exchanger(transaction_abbreviation,wallet_abbreviation)
    url = "https://free.currconv.com/api/v7/convert?q=#{transaction_abbreviation}_#{wallet_abbreviation}&compact=ultra&apiKey=e7774d79343719090739"
    response = Faraday.get(url, {'Accept' => 'application/json'})
    if(response.status == 200)
        btn_price = JSON.parse(response.body)
        btn_price["#{transaction_abbreviation}_#{wallet_abbreviation}"]
    else
      "something went wrong"
    end

  end

  #Check transaction type
	def action(transaction_params,current_user)
	  if transaction_params.transaction_type == "deposit"
        deposit(transaction_params,current_user)
      elsif transaction_params.transaction_type == "withdraw"
        withdraw(transaction_params,current_user)
      end
	end

	def check_status(transaction_status)
     if transaction_status.save
       transaction_status
     else
       transaction_status.errors
     end
    end

	#Add amount to wallet
    def add_to_wallet(user_id,wallet_id,amount,abbreviation)
        wallet = Wallet.find_by(user_id: user_id,id: wallet_id)
        wallet_abbreviation = Currency.find(wallet.currency_id).abbreviation
        transaction_abbreviation = Currency.find(abbreviation).abbreviation
        if(wallet_abbreviation == transaction_abbreviation)
          wallet.increment(:amount,amount)
        else
          exchanged_currency = currency_exchanger(transaction_abbreviation,wallet_abbreviation)
          new_amount = exchanged_currency * amount
          wallet.increment(:amount,new_amount)
        end
        wallet.save
    end

    #Reduce amount to wallet
    def deduct_from_wallet(user_id,wallet_id,amount,abbreviation)
        wallet = Wallet.find_by(user_id: user_id,id: wallet_id)
        wallet_abbreviation = Currency.find(wallet.current_id).abbreviation
        transaction_abbreviation = Currency.find(abbreviation).abbreviation
        if(wallet_abbreviation == transaction_abbreviation)
          wallet.decrement(:amount,amount)
        else
          exchanged_currency = currency_exchanger(transaction_abbreviation,wallet_abbreviation)
          new_amount = exchanged_currency * amount
          wallet.decrement(:amount,new_amount)
        end
        wallet.save
    end

    #Withdraw funds from wallet
    def withdraw(transaction_params,current_user)
      if current_user.admin?
      notification = { message: 'Unauthorised: Only Noobs and Elite users can withdraw!'}
      render json: notification
      else
        transaction_params.user_id = current_user.id
        transaction_params.status = "successful"
        deduct_from_wallet(transaction_params.user_id,transaction_params.wallet_id,transaction_params.amount,transaction_params.currency_id)
        check_status(transaction_params)
      end
    end

    #deposit funds to wallet
    def deposit(transaction_params,current_user)
        if current_user.admin?
          transaction_params.status = "successful"
          add_to_wallet(transaction_params.user_id,transaction_params.wallet_id,transaction_params.amount,transaction_params.currency_id)
          check_status(transaction_params)
        elsif current_user.elite?
          transaction_params.user_id = current_user.id
          transaction_params.confirm = false
          transaction_params.status = "pending"
          notification = { message: 'Deposit has been sent for approval'}
          transaction_params.save
          notification
        else
          transaction_params.user_id = current_user.id
          transaction_params.confirm = true
          transaction_params.status = "successful"
          add_to_wallet(current_user.id,transaction_params.wallet_id,transaction_params.amount,transaction_params.currency_id)
          check_status(transaction_params)
        end
    end
end