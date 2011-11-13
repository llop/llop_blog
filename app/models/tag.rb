class Tag < ActiveRecord::Base
  
  # Associations
  has_and_belongs_to_many :posts
  
  # Validations
  validates :name,  :presence => true,  :length => { :maximum => 32 }
  
  # Tag cloud stuff
  def self.cloud_data_cached
    Rails.env.development? ? cloud_data : Rails.cache.fetch('tags_data') { cloud_data }
  end
  def self.cloud_data
    query = "select count(id) as count, t.id as id, t.name as name " +
            "from posts_tags as pt, tags as t where pt.tag_id = t.id " +
            "group by id, t.id, t.name order by count desc limit 20"
    tags_data = find_by_sql query
    unless tags_data.empty?
      least = tags_data.last[:count].to_i
      tags_data.each { |tag_data| tag_data[:count] = tag_data[:count].to_i - least }
      tags_data.shuffle!
    end
    tags_data
  end
  
end
