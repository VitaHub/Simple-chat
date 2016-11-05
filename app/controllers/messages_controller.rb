class MessagesController < ApplicationController
	before_action :authenticate_user!
  include ActionView::Helpers::TextHelper

	def create
  	@message = Message.new(message_params)
    if @message.save
    	chat = ChatRoom.find(@message.chat_room_id)

      ActionCable.server.broadcast "chat_#{@message.chat_room_id}",
        message: simple_format(@message.body),
        sender_name: @message.sender.name || @message.sender.email,
        sender_id: @message.sender_id

    end

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