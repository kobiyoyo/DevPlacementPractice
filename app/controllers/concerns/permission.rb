module Permission
	def authorize_admin
      return unless !@current_user.admin?
      response = { message: 'Unauthorised: Only Admin can have access!'}
      render json: response
    end
    def authorize_agent
      return unless !@current_user.agent?
      response = { message: 'Unauthorised: Only Elite can have access!'}
      render json: response
    end
end