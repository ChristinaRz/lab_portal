class Group::Message < ApplicationRecord
  self.table_name = 'group_messages'

  #λίστα χρηστών που είδαν το μήνυμα
  serialize :seen_by, coder: JSON
  #λίστα νέων χρηστών που προστέθηκαν
  serialize :added_new_users, coder: JSON

  #κάθε μήνυμα ανήκει σε μια ομαδική συνομιλία
  belongs_to :conversation,
             class_name: 'Group::Conversation',
             foreign_key: 'conversation_id'
  #καθε μήνυμα ανήκει σε έναν χρήστη
  belongs_to :user

  validates :content, presence: true
  validates :user_id, presence: true
  validates :conversation_id, presence: true

  #φορτώνεται πάντα ο χρήστης μαζί με το μήνυμα
  default_scope { includes(:user) }

  def previous_message
    #επιστρέφει το προηγούμενο μήνυμα της συνομιλίας
    previous_message_index = conversation.messages.index(self) - 1
    conversation.messages[previous_message_index]
  end
end