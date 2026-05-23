class User < ApplicationRecord
  #Devise modules για αυθεντικοποίηση
  devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :validatable,
       :omniauthable, omniauth_providers: [:google_oauth2]
 
 
  #ενας χρήστης έχει πολλά posts
  has_many :posts, dependent: :destroy
  #ενας χρήστης έχει πολλά σχόλια
  has_many :comments, dependent: :destroy
  #ενας χρήστης έχει πολλές επαφές
  has_many :contacts, dependent: :destroy
  #φέρνει τους χρήστες που είναι στις επαφές
  has_many :contact_users, through: :contacts, source: :contact_user
 
#ιδιωτικές συνομιλίες ως αποστολέας
  has_many :sent_conversations, foreign_key: :sender_id, class_name: 'Private::Conversation'
  #ιδιωτικές συνομιλίες ως παραλήπτης
  has_many :received_conversations, foreign_key: :recipient_id, class_name: 'Private::Conversation'
 
  #ομαδικές συνομιλίες μέσω join table
has_and_belongs_to_many :group_conversations, 
                        class_name: 'Group::Conversation',
                        join_table: :group_conversations_users,
                        foreign_key: :user_id,
                        association_foreign_key: :group_conversation_id
 
  #token για αυθεντικοποίηση μέσω API
  has_secure_token :auth_token
 
  #όνομα υποχρεωτικό για εγγραφή 
 
  private
 
  def from_omniauth?
    provider.present?
  end
 
 
  def self.from_omniauth(auth)
  #βρίσκεται ή δημιουργείται χρήστης από τα Google δεδομένα
  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0, 20]
    user.name = auth.info.name
  end
end
end
 
