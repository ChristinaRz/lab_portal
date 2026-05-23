class CreateGroupConversationsUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :group_conversations_users do |t|
      t.integer :group_conversation_id
      t.integer :user_id

      t.timestamps
    end
  end
end
