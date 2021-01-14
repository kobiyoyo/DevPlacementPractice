class TransactionAction

	def action(transaction_params,current_user)
	  if transaction_params.transaction_type == "deposit"
        deposit(transaction_params,current_user)
      elsif transaction_params.transaction_type == "withdraw"
        withdraw(transaction_params,current_user)
      end
	end

	def check_status(transaction)
     if transaction.save
       transaction
     else
       transaction.errors
     end
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
    def withdraw(transaction_params,current_user)
      if current_user.admin?
      notification = { message: 'Unauthorised: Only Noobs and Elite users can withdraw!'}
      render json: notification
      else
        transaction_params.user_id = current_user.id
        transaction_params.status = "successful"
        deduct_from_wallet(transaction_params.user_id,transaction_params.wallet_id,transaction_params.amount)
        check_status(transaction_params)
      end
    end

    #deposit funds to wallet
    def deposit(transaction_params,current_user)
        if current_user.admin?
          transaction_params.status = "successful"
          add_to_wallet(transaction_params.user_id,transaction_params.wallet_id,transaction_params.amount)
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
          add_to_wallet(current_user.id,transaction_params.wallet_id,transaction_params.amount)
          check_status(transaction_params)
        end
    end
end