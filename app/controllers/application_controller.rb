class Timer
	def initialize(time, &block)
		@time = time; @block = block; @a = nil
	end

	def start
		@a = Thread.new { sleep @time; @block.call }
		puts "Timer #{@a} started at #{Time.now}"
	end

	def stop
		puts "Timer #{@a} killed at #{Time.now}"
		@a.kill; @a = nil
	end

	def restart
		stop if @a != nil; start
	end
end

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :user_activity

  $timer ||= [] 

  protected

	  def configure_permitted_parameters
	      devise_parameter_sanitizer.permit(:sign_up) do |u| 
	      	u.permit(:name, :email, :password, :password_confirmation) 
	      end
	  end

		def user_activity
		  current_user.try :touch
		  update_status
			if user_signed_in?
				$timer[current_user.id] ||= Timer.new(301) { update_status }
			  $timer[current_user.id].restart
			end
		end

  	def update_status
			if user_signed_in?
				puts "Broadcasting at #{Time.now}"
	  		ActionCable.server.broadcast "chat_list",
	        update_list: true,
	        user: current_user.id,
	        status: current_user.status
			end
  	end

end
