class Post < ActiveRecord::Base
  
  # Associations
  has_and_belongs_to_many :tags
  belongs_to :category
  has_many :comments
  
  # Validations
  validates :title,     :presence => true,  :length => { :maximum => 255 }
  validates :summary,   :presence => true,  :length => { :maximum => 1024 }
  validates :body,      :presence => true
  validates :category,  :presence => true
  
  # Set per-page pagination value
  self.per_page = 5
  
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
  
end
