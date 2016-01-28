class Collection << ActiveRecord::Base
  has_many :saved_phrases
end