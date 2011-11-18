atom_feed do |feed|
  feed.title 'Latest posts'
  feed.updated @posts.first.updated_at
  @posts.each do |post|
    feed.entry post do |entry|
      entry.title post.title, type: 'html'
      entry.content post.summary, type: 'html'
    end
  end
end