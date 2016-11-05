class UsersChatRooms < ActiveRecord::Migration[5.0]
  def change
  	create_join_table :users, :chat_rooms
  end
end
