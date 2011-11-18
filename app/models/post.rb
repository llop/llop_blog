class Post < ActiveRecord::Base
  
  # Associations
  has_and_belongs_to_many :tags
  belongs_to :category
  has_many :comments
  
  # Validations
  validates :title,     :presence => true,  :length => { :maximum => 128 }
  validates :summary,   :presence => true,  :length => { :maximum => 1024 }
  validates :body,      :presence => true
  validates :category,  :presence => true
  
  def tag_ids=(id_arr = [])
    to_delete = []
    tags.each do |tag|
      tag_id = tag.id.to_s
      id_arr.include?(tag_id) ? id_arr.delete(tag_id) : (to_delete << tag)
    end
    to_delete.each { |tag| tags.delete tag }
    id_arr.each { |tag_id| tags << Tag.find(tag_id.to_i) }
  end
  
  # Set per-page pagination value
  self.per_page = 10
  
  # Methods
  def self.search(search, page) 
    words = search.split
    query_string = 
    "select * from posts where ((" +
      "setweight(to_tsvector('pg_catalog.english', title), 'A') || " + 
      "setweight(to_tsvector('pg_catalog.english', summary), 'B') || " + 
      "setweight(to_tsvector('pg_catalog.english', body), 'D')" + 
    ")) @@ to_tsquery('#{words.map{|w|connection.quote_string(w)}.join('|')}')"
    paginate_by_sql [ query_string ], :page => page
  end
  
  def self.search_by_tag_id(tag_id, page)
    query_string = "select p.* from posts as p, posts_tags as pt " + 
                   "where p.id = pt.post_id and pt.tag_id = ? order by p.created_at desc"
    paginate_by_sql [ query_string, tag_id ], :page => page
  end
  
  def self.archives_cached
    Rails.env.development? ? archives : Rails.cache.fetch('archives_data') { archives }
  end
  def self.archives
    query = "select distinct extract(year from p.created_at) as year, extract(month from p.created_at) as month, count (p.created_at) as count " + 
            "from posts as p group by p.created_at order by year desc, month desc"
    find_by_sql query
  end
    
end
