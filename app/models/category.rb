class Category < ActiveRecord::Base
  
  # Associations
  has_many :posts
  
  # Validations
  validates :name,  :presence => true,  :length => { :maximum => 32 }
  
  def self.order_by_name_asc_cached
    Rails.env.development? ? order("name asc").all : Rails.cache.fetch('categories_data') { order("name asc").all }
  end
  
end
