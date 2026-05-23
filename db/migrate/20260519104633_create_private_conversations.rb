class CreatePrivateConversations < ActiveRecord::Migration[8.1]
  def change
    create_table :private_conversations do |t|
      t.integer :sender_id
      t.integer :recipient_id

      t.timestamps
    end
  end
end
