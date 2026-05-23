class Category < ApplicationRecord
	#μια κατηγορία έχει πολλά posts
	has_many :posts
end
