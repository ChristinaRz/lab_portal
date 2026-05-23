class Comment < ApplicationRecord
  #κάθε comment ανήκει σε έναν χρήστη (ποιος το έγραψε)
  belongs_to :user

  #κάθε comment ανήκει σε ένα post (πού το έγραψε)
  belongs_to :post

  #δεν επιτρέπεται κενό σχόλιο
  validates :body, presence: true
end
