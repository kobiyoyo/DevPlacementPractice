Rails.application.routes.draw do

	  namespace :api do
	    namespace :v1 do
	    	resources :users
	    	resources :transactions
  			resources :wallets
  			resources :currencies
	    end
	  end

	  # Transactions
	  # post 'api/v1/withdraw', to: 'api/v1/transactions#widthdraw'
	  # post 'api/v1/deposit', to: 'api/v1/transactions#deposit'

	  #Authentication
	  post 'auth/register', to: 'api/v1/users#register'
	  post 'auth/login', to: 'api/v1/users#login'
end
