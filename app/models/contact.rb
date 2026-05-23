class Contact < ApplicationRecord
  #ο χρήστης που κρατάει τη λίστα επαφών
  belongs_to :user
  #ο χρήστης που προστίθεται ως επαφή
  belongs_to :contact_user, class_name: 'User', foreign_key: 'contact_user_id'

  #δεν επιτρέπεται διπλή εγγραφή της ίδιας επαφής
  validates :contact_user_id, uniqueness: { scope: :user_id }
end