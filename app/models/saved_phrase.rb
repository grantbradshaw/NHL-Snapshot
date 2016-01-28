class SavedPhrase < ActiveRecord::Base
  
  belongs_to :collection
  validates :phrase, presence: true
  
end