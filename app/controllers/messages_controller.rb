class MessagesController < ApplicationController
	before_action :authenticate_user!

	def create
  	@message = Message.create(message_params)
  	chat = ChatRoom.find(@message.chat_room_id)
  	respond_to do |format|
	   	format.html { redirect_to chat_room_path(chat) }
      format.js {head :ok}
    end
	end

  private
  	def message_params
  		params.require(:message).permit(:body, :sender_id, :recipient_id, :chat_room_id)
  	end
end