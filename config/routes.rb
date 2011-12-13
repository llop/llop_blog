LlopBlog::Application.routes.draw do
  
  # RESTful stuff
  # Try to route only to working actions using :only constraint
  # Make urls more descriptive prefixing everything with '/blog'
  scope "/blog" do
    # Posts
    get 'posts(/page/:page)' => 'posts#index', :as => 'posts', :page => /\d+/ 
    get 'posts/:id' => 'posts#show', :as => 'post', :id => /\d+/
    post 'posts/:post_id/comments' => 'comments#create', :as => 'post_comments', :post_id => /\d+/
    get 'search', :controller => 'posts'
    # Categories
    get 'categories/:id(/page/:page)' => 'categories#show', :as => 'category', :id => /\d+/, :page => /\d+/
    # Tags
    get 'tags/:id(/page/:page)' => 'tags#show', :as => 'tag', :id => /\d+/, :page => /\d+/
    # archives
    get 'archives/:year/:month(/page/:page)' => 'posts#archives', :as => 'archives', :year => /\d{4}/, :month => /\d{1,2}/, :page => /\d+/
    get 'feed' => 'posts#index', :as => 'feed', :defaults => { :format => 'atom' }
  end
  match 'blog' => 'posts#index', :via => :get
  
  # Admin section
  scope "/admin" do
    # Posts
    get 'posts(/page/:page)' => 'admin_posts#index', :as => 'admin_posts', :page => /\d+/ 
    resources :posts, :controller => 'admin_posts', :only => [ :new, :create, :edit, :update ]
    resources :comments, :controller => 'admin_comments', :only => [ :destroy ]
    get 'search', :controller => 'admin_posts', :as => 'admin_search'
    # Categories
    get 'categories/:id(/page/:page)' => 'admin_categories#show', :as => 'admin_category', :id => /\d+/, :page => /\d+/
    resources :categories, :controller => 'admin_categories', :only => [ :create ], :as => 'admin_categories'
    # Tags
    get 'tags/:id(/page/:page)' => 'admin_tags#show', :as => 'admin_tag', :id => /\d+/, :page => /\d+/
    resources :tags, :controller => 'admin_tags', :only => [ :create ], :as => 'admin_tags'
    # Categories and tags get created from the same place
    get 'categories_tags', :controller => 'admin_categories_tags', :as => 'categories_tags'
  end
  get 'admin' => 'admin_posts#index'
  
  # Buddhabrot section
  scope '/buddhabrot' do
    get 'article/:id' => 'buddhabrot#article', :as => 'buddha_article', :id => /\d+/
    get 'appendix/:id' => 'buddhabrot#appendix', :as => 'buddha_appendix', :id => /\d+/
    get 'applet/:id' => 'buddhabrot#applet', :as => 'buddha_applet', :id => /\d+/
    get 'gallery' => 'buddhabrot#gallery', :as => 'buddha_gallery'
  end
  get 'buddhabrot' => 'buddhabrot#gallery'
  
  scope '/informatica_upc' do
    get 'practica_pro2' => 'prac_pro2#index', as: 'prac_pro2'
    get 'practica_pro2/file/:id' => 'prac_pro2#file', as: 'prac_pro2_file', :id => /\d+/
    post 'practica_pro2/jp_tester' => 'prac_pro2#jp_tester', as: 'jp_tester'
  end
  get 'informatica_upc' => 'informatica#index', as: 'informatica_home'
  
  # About section
  get 'about' => 'home#about', as: 'about'
  
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
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
  
  # Handles routing errors
  # You can find the rouge route as params[:a]
  match '*a', :to => 'application#routing_error'
end
