class Category < ActiveRecord::Base
  
  # Associations
  has_many :posts
  
  # Validations
  validates :name,  :presence => true,  :length => { :maximum => 32 }
  
end
