class Post < ApplicationRecord
  #κάθε post ανήκει σε έναν χρήστη
  belongs_to :user
  #ενα post έχει πολλά σχόλια
  has_many :comments, dependent: :destroy
  #ενα post ανήκει σε μια κατηγορία
  belongs_to :category, optional: true

  #τίτλος και σώμα υποχρεωτικά
  validates :title, presence: true
  validates :body, presence: true

  #αναζήτηση posts με βάση τίτλο ή σώμα
  scope :search, ->(query) {
    where("title ILIKE ? OR body ILIKE ?", "%#{query}%", "%#{query}%")
  }

  #φιλτράρισμα posts με βάση κατηγορία
  scope :by_category, ->(category_id) {
    where(category_id: category_id)
  }
end