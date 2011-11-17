class CommentsSweeper < ActionController::Caching::Sweeper
  
  # watch comments
  observe Comment
  
  # Add callbacks
  def after_create(comment)
    expire_bulk(comment.post)
  end
  
  def after_update(comment)
    expire_cache_for(comment.post)
  end
  
  def after_destroy(comment)
    expire_bulk(comment.post)
  end

private
  def expire_cache_for(post)
    expire_fragment :controller => 'posts', :action => 'show', :id => post.id
  end
  
  def expire_bulk(post)
    expire_fragment %r{admin/categories/#{post.category_id}}
    expire_fragment %r{blog/categories/#{post.category_id}}
    post.tags.each do |tag| 
      expire_fragment %r{admin/tags/#{tag.id}}
      expire_fragment %r{blog/tags/#{tag.id}}
    end
    expire_fragment %r{admin/posts}
    expire_fragment %r{blog/posts}
    expire_fragment %r{blog/archives/#{post.created_at.year}/#{post.created_at.month}}
    expire_cache_for post
  end

end