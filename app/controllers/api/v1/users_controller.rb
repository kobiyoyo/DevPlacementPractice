class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register]

  def index
    @users = User.all.order('created_at DESC')

    render json: @users
  end

  # POST /register
  def register
    @user = User.create(user_params)
    if @user.save
      response = { message: 'User created successfully' }
      render json: response, status: :created
    else
      render json: @user.errors, status: :bad
    end
  end

  def login
    authenticate params[:email], params[:password]
  end

  private

  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)

    if command.success?
      render json: {
        access_token: command.result,
        message: 'Login Successful'
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
   end

  def user_params
    params.permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :active,
      :phone
    )
  end
end
