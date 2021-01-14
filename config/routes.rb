Rails.application.routes.draw do

	  namespace :api do
	    namespace :v1 do
	    	resources :users
	    	resources :transactions
  			resources :wallets
  			resources :currencies
	    end
	  end
	  post 'auth/register', to: 'api/v1/users#register'
	  post 'auth/login', to: 'api/v1/users#login'
end
