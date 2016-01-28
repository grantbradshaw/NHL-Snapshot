class SavedPhrase < ActiveRecord::Base
  validates :phrase, presence: true
  
end