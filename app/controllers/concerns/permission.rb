module Permission
	def authorize_admin
      return unless !@current_user.admin?
      response = { message: 'Unauthorised: Only Admin can have access!'}
      render json: response
    end
    def authorize_elite_or_noob
      return unless !(@current_user.elite? || @current_user.noob?)
      response = { message: 'Unauthorised: Only Elite and Noob users can have access!'}
      render json: response
    end
end