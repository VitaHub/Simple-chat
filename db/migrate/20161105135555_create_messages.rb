class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
    	t.integer :recipient_id
      t.integer :sender_id
      t.integer :chat_room_id
      t.text :body, null: false

      t.timestamps
    end
  end
end
