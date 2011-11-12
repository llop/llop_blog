LlopBlog::Application.routes.draw do
  
  # RESTful stuff
  # Try to route only to working actions using :only constraint
  # Make urls more descriptive prefixing everything with '/blog'
  scope "/blog" do
    resources :posts, :only => [ :index, :show ] do
      resources :comments, :only => [ :create ]
    end
    resources :categories, :only => [ :show ]
    resources :tags, :only => [ :show ]
    get 'search', :controller => 'posts'
    match 'archives/:year/:month' => 'posts#archives', :via => :get, :as => 'archives'
  end
  match 'blog' => 'posts#index', :via => :get
  
  # Admin section
  scope "/admin" do
    resources :posts, :controller => 'admin_posts', :only => [ :index, :new, :create, :edit, :update ]
    resources :comments, :controller => 'admin_comments', :only => [ :destroy ]
    get 'search', :controller => 'admin_posts', :as => 'admin_search'
    resources :categories, :controller => 'admin_categories', :only => [ :show, :create ], :as => 'admin_categories'
    resources :tags, :controller => 'admin_tags', :only => [ :show, :create ], :as => 'admin_tags'
    get 'categories_tags', :controller => 'admin_categories_tags', :as => 'categories_tags'
  end
  match 'admin' => 'admin_posts#index'

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
