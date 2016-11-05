class MainController < ApplicationController
	def index
		if user_signed_in?
			@users = User.all.where.not(id: current_user.id)
		end
	end
end