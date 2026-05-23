class CreateGroupMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :group_messages do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.integer :conversation_id
      t.text :seen_by
      t.text :added_new_users

      t.timestamps
    end
  end
end
