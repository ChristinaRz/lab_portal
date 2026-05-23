
class Private::Message < ApplicationRecord
  self.table_name = 'private_messages'
 
  #μετά τη δημιουργία μηνύματος 
  #εκτελείται broadcast για real-time
  after_create_commit do
    Private::MessageBroadcastJob.perform_now(self, previous_message)
  end
 
  #κάθε μήνυμα ανήκει σε έναν χρήστη
  belongs_to :user
  #κάθε μήνυμα ανήκει σε μια ιδιωτική συνομιλία
  belongs_to :conversation,
             class_name: 'Private::Conversation',
             foreign_key: :conversation_id
 
  validates :body, presence: true
  validates :user_id, presence: true
 
  def previous_message
    #επιστρέφει το προηγούμενο μήνυμα της συνομιλίας
    #αν είναι το πρώτο μήνυμα (index 0), επιστρέφει nil
    index = conversation.messages.index(self)
    return nil if index == 0
    conversation.messages[index - 1]
  end
end
