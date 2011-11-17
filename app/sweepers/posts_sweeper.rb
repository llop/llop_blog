class PostsSweeper < ActionController::Caching::Sweeper
  
  # watch posts
  observe Post
  
  # Add callbacks
  def after_create(post)
    expire_cache_for(post)
  end
  
  def after_update(post)
    expire_update_or_destroy(post)
  end
  
  def after_destroy(post)
    expire_update_or_destroy(post)
  end

private
  def expire_update_or_destroy(post)
    expire_cache_for(post)
    expire_fragment :controller => 'posts', :action => 'show', :id => post.id
  end
  
  def expire_cache_for(post)
    expire_fragment 'sidebar'
    expire_fragment %r{admin/categories/#{post.category_id}}
    expire_fragment %r{blog/categories/#{post.category_id}}
    post.tags.each do |tag| 
      expire_fragment %r{admin/tags/#{tag.id}}
      expire_fragment %r{blog/tags/#{tag.id}}
    end
    expire_fragment %r{admin/posts}
    expire_fragment %r{blog/posts}
    expire_fragment %r{blog/archives/#{post.created_at.year}/#{post.created_at.month}}
    Rails.cache.delete 'tags_data'
    Rails.cache.delete 'categories_data'
    Rails.cache.delete 'archives_data'
  end

end