class Group::Conversation < ApplicationRecord
  self.table_name = 'group_conversations'
 
  #μια ομαδική συνομιλία έχει πολλούς χρήστες
  has_and_belongs_to_many :users,
    join_table: 'group_conversations_users',
    foreign_key: 'group_conversation_id',
    association_foreign_key: 'user_id'
  #και πολλά μηνύματα
  has_many :messages,
           class_name: 'Group::Message',
           foreign_key: 'conversation_id',
           dependent: :destroy
end
