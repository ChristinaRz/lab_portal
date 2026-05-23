class Private::Conversation < ApplicationRecord
  self.table_name = 'private_conversations'
 
  #μια ιδιωτική συνομιλία έχει πολλά μηνύματα
  has_many :messages,
           class_name: 'Private::Message',
           foreign_key: :conversation_id
  #αποστολέας
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  #παραλήπτης
  belongs_to :recipient, foreign_key: :recipient_id, class_name: 'User'
 
  #αποτροπή duplicate συνομιλία μεταξύ των ίδιων δύο χρηστών
  validates :sender_id, uniqueness: { scope: :recipient_id,
    message: "Conversation already exists" }
 
  #βρίσκει συνομιλία μεταξύ δύο χρηστών και στις δύο κατευθύνσεις
  scope :between_users, ->(user1_id, user2_id) do
    where(sender_id: user1_id, recipient_id: user2_id).or(
      where(sender_id: user2_id, recipient_id: user1_id)
    )
  end
 
  #βρίσκει όλες τις συνομιλίες ενός χρήστη
  scope :all_by_user, ->(user_id) do
    where(recipient_id: user_id).or(where(sender_id: user_id))
  end
 
  def opposed_user(user)
    #επιστρέφει τον άλλον χρήστη της συνομιλίας
    user == recipient ? sender : recipient
  end
end
