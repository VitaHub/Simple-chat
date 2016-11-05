class ChatRoomsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_chat, only: :show

	def show
		@chat_room = ChatRoom.find(params[:id])
		@messages = @chat_room.messages
		@message = Message.new
		@interlocutor = @chat_room.users.where.not(id: current_user.id)[0]
	end

	def create
		recipient_id = params[:recipient_id]
		@chat_room = current_user.chat_rooms.includes(:users)
				.find_by(users: {id: recipient_id})
		unless @chat_room
			@chat_room = ChatRoom.new
			@chat_room.users << current_user
			@chat_room.users << User.find(recipient_id)
	    @chat_room.save
		end

    redirect_to chat_room_path(@chat_room) 
	end

	def set_chat
		@chat_room = ChatRoom.where(id: params[:id])[0]
		unless @chat_room
			redirect_to root_path, alert: "Chat room doesn't exist!"
		else
			redirect_to root_path, alert: "Access denied!" unless 
				@chat_room.users.find_by(id: current_user.id)
		end
	end
end