class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :user_activity

  protected

	  def configure_permitted_parameters
	      devise_parameter_sanitizer.permit(:sign_up) do |u| 
	      	u.permit(:name, :email, :password, :password_confirmation) 
	      end
	  end

		def user_activity
		  current_user.try :touch
		  update_status
		  # Thread.new {
		  # 	sleep 301
		  # 	update_status
		  # }
		end

  	def update_status
			if user_signed_in?
	  		ActionCable.server.broadcast "chat_list",
	        update_list: true,
	        user: current_user.id,
	        status: current_user.status
			end
  	end

end
