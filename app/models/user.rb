class User < ActiveRecord::Base

  has_many :collections
  has_many :upvotes

  def has_upvoted_collection?(collection)
    self.upvotes.where(collection_id: collection.id).exists?
  end

end