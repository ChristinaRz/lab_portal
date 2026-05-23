class CreatePrivateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :private_messages do |t|
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.integer :conversation_id
      t.boolean :seen

      t.timestamps
    end
  end
end
