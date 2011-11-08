class Tag < ActiveRecord::Base
  
  # Associations
  has_and_belongs_to_many :posts
  
  # Validations
  validates :name,  :presence => true,  :length => { :maximum => 32 }
  
end
