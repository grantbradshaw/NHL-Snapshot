class Collection < ActiveRecord::Base
  
  belongs_to :user
  has_many :saved_phrases
  has_many :upvotes

end