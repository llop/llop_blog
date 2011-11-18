class Comment < ActiveRecord::Base
  
  # Associations
  belongs_to :post
  
  # Validations
  validates :name,  :presence => true,  :length => { :maximum => 36 }
  validates :email, :presence => true,  :length => { :maximum => 128 },   :email => true
  validates :uri,                       :length => { :maximum => 128 },   :uri => true
  validates :body,  :presence => true,  :length => { :maximum => 1024 }
  validates :post,  :presence => true
  
  # Callbacks
  before_save do |comment|
    comment.uri = nil if comment.uri.empty?
  end
  after_create do |comment|
    begin
      AdminMailer.comment_created(comment).deliver
    rescue Exception => e
      puts e.message  
      puts e.backtrace.inspect  
    end
  end
  
end
