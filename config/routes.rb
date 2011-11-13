LlopBlog::Application.routes.draw do
  
  # RESTful stuff
  # Try to route only to working actions using :only constraint
  # Make urls more descriptive prefixing everything with '/blog'
  scope "/blog" do
    # Posts
    match 'posts/page/:page' => 'posts#index', :via => :get, :as => 'posts_page'
    match 'posts' => 'posts#index', :via => :get, :as => 'posts'
    resources :posts, :only => [ :show ] do
      resources :comments, :only => [ :create ]
    end
    get 'search', :controller => 'posts'
    # Categories
    match 'categories/:id/page/:page' => 'categories#show', :via => :get, :as => 'category_page'
    match 'categories/:id' => 'categories#show', :via => :get, :as => 'category'
    # Tags
    match 'tags/:id/page/:page' => 'tags#show', :via => :get, :as => 'tag_page'
    match 'tags/:id' => 'tags#show', :via => :get, :as => 'tag'
    # archives
    match 'archives/:year/:month/page/:page' => 'posts#archives', :via => :get, :as => 'archives_page'
    match 'archives/:year/:month' => 'posts#archives', :via => :get, :as => 'archives'
  end
  match 'blog' => 'posts#index', :via => :get
  
  # Admin section
  scope "/admin" do
    # Posts
    match 'posts/page/:page' => 'admin_posts#index', :via => :get, :as => 'admin_posts_page'
    match 'posts' => 'admin_posts#index', :via => :get, :as => 'admin_posts'
    resources :posts, :controller => 'admin_posts', :only => [ :new, :create, :edit, :update ]
    resources :comments, :controller => 'admin_comments', :only => [ :destroy ]
    get 'search', :controller => 'admin_posts', :as => 'admin_search'
    # Categories
    match 'categories/:id/page/:page' => 'admin_categories#show', :via => :get, :as => 'admin_category_page'
    match 'categories/:id' => 'admin_categories#show', :via => :get, :as => 'admin_category'
    resources :categories, :controller => 'admin_categories', :only => [ :create ], :as => 'admin_categories'
    # Tags
    match 'tags/:id/page/:page' => 'admin_tags#show', :via => :get, :as => 'admin_tag_page'
    match 'tags/:id' => 'admin_tags#show', :via => :get, :as => 'admin_tag'
    resources :tags, :controller => 'admin_tags', :only => [ :create ], :as => 'admin_tags'
    # Categories and tags get created from the same place
    get 'categories_tags', :controller => 'admin_categories_tags', :as => 'categories_tags'
  end
  match 'admin' => 'admin_posts#index', :via => :get

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  get "home/index"
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  
  # Handles routing errors
  # You can find the rouge route as params[:a]
  match '*a', :to => 'application#routing_error'
end
