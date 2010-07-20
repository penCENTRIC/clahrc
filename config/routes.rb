Clahrc::Application.routes.draw do |map|
  constraints CommunitySubdomain do
    resources :members, :controller => :users, :only => [ :new, :edit, :create, :update ], :path_names => {  :new => 'register', :edit => 'activate' }
    resource :session, :controller => :user_sessions, :only => [ :new, :create, :destroy ], :path_names => { :new => 'login' }
    resources :passwords, :only => [ :new, :edit, :create, :update ], :path_names => { :new => 'reset', :edit => 'reset' }

    # Members
    resources :members, :only => [ :index, :show ], :collection => { :autocomplete => :get }, :paged => { :name => :directory } do
      # Activities
      resources :activity, :controller => :ativities, :only => [ :index ], :paged => { :name => :directory }

      # Friendships
      resources :friends, :controller => :friendships, :only => [ :index, :create ], :paged => { :name => :directory }

      # Memberships
      resources :groups, :controller => :memberships, :only => [ :index ], :paged => { :name => :directory }

      # Messages
      resources :messages, :only => [ :new, :create ]

      # Assets
      resources :files, :controller => :assets, :only => [ :index ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }

      # Content
      resources :pages, :only => [ :index ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }
      resources :posts, :only => [ :index ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }
      resources :wiki, :controller => :wiki_pages, :only => [ :index, :show ]
    end

    # Groups
    resources :groups, :paged => { :name => :directory } do
      # Activitites
      resources :activity, :controller => :activities, :only => [ :index ], :paged => { :name => :directory }

      # Memberships
      resources :members, :controller => :memberships, :collection => { :pending => :get, :invite => :post }, :member => { :accept => :put, :promote => :put, :reject => :delete }, :only => [ :index, :new, :create ], :paged => { :name => :directory }
      resources :moderators, :controller => :moderatorships, :member => { :promote => :put }, :only => [ :index ], :paged => { :name => :directory }
      resources :owners, :controller => :ownerships, :only => [ :index ], :paged => { :name => :directory }

      # Messages
      resources :messages, :only => [ :new, :create ]

      # Assets
      resources :files, :controller => :assets, :only => [ :index, :new, :create ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }

      # Content
      resources :forums, :only => [ :index, :new, :create ], :paged => { :name => :directory }
      resources :pages, :only => [ :index, :new, :create ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }
      resources :wiki, :controller => :wiki_pages
    end

    # Assets
    resources :files, :controller => :assets, :only => [ :show, :edit, :update, :destroy ]

    # Forums
    resources :forums, :only => [ :show, :edit, :update, :destroy ] do
      resources :topics, :only => [ :index, :new, :create ], :paged => { :name => :directory }
    end

    # Pages
    resources :pages, :only => [ :show, :edit, :update, :destroy ] do
      resources :comments, :only => [ :index, :new, :create ], :paged => { :name => :directory }
    end

    # Posts
    resources :posts, :only => [ :show, :edit, :update, :destroy ] do 
      resources :comments, :only => [ :index, :new, :create ], :paged => { :name => :directory }
    end

    # Topics
    resources :topics, :only => [ :show, :edit, :update, :destroy ] do 
      resources :comments, :only => [ :index, :new, :create ], :paged => { :name => :directory }
    end

    # Search
    match '/search', :to => 'search#index'
    match '/search/forums', :to => 'search#forums'
    match '/search/groups', :to => 'search#groups'
    match '/search/members', :to => 'search#members'
    match '/search/pages', :to => 'search#pages'
    match '/search/posts', :to => 'search#posts'
    match '/search/topics', :to => 'search#topics'
    match '/search/wiki_pages', :to => 'search#wiki_pages'

    # Comments
    resources :comments, :only => [ :show, :edit, :update, :destroy ], :member => { :reply => :get }

    # Tags
    resources :tags, :only => [ :index, :show ]
  end
  
  constraints MySubdomain do
    with_options :name_prefix => 'my' do |my|
      # Settings
      my.resource :account, :only => [ :show, :edit, :update ]

      # Profile
      my.resource :avatar, :only => [ :edit, :update ]
      my.resource :profile, :only => [ :edit, :update ]

      # Activities
      my.resources :activity, :controller => :activities, :only => [ :index ], :paged => { :name => :directory }

      # Assets
      my.resources :files, :as => :assets, :paged => { :name => :directory }

      # Content
      my.resources :pages, :collection => { :sort => :put }, :paged => { :name => :directory }
      my.resources :posts, :paged => { :name => :directory }
      my.resources :wiki, :controller => :wiki_pages

      # Friendships
      my.resources :friends, :controller => :friendships, :collection => { :pending => :get }, :member => { :accept => :put, :reject => :delete }, :only => [ :index, :create, :destroy ], :paged => { :name => :directory }

      # Messages
      my.resources :sent, :controller => :sent_messages, :only => [ :index, :show, :destroy ], :path_prefix => 'messages', :paged => { :name => :directory }
      my.resources :messages, :controller => :received_messages, :only => [ :index, :show, :destroy ], :collection => { :unread => :get }, :member => { :reply => :get }, :paged => { :name => :directory }

      # Memberships
      my.resources :groups, :controller => :memberships, :collection => { :invited => :get }, :member => { :accept => :put, :reject => :delete }, :only => [ :index, :destroy ], :paged => { :name => :directory }
    end
  end
end
