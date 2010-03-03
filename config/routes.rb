ActionController::Routing::Routes.draw do |map|
  # my.clahrc.net
  map.subdomain :my, :name => nil, :name_prefix => 'my_' do |my|
    # Settings
    my.resource :account, :only => [ :show, :edit, :update ]

    # Profile
    my.resource :avatar, :only => [ :edit, :update ]
    my.resource :profile, :only => [ :edit, :update ]

    # Activities
    my.resources :activities, :as => 'activity', :only => [ :index ], :paged => { :name => :directory }

    # Assets
    my.resources :assets, :as => 'files', :paged => { :name => :directory }

    # Content
    my.resources :pages, :collection => { :sort => :put }, :paged => { :name => :directory }
    my.resources :posts, :paged => { :name => :directory }
    
    # Friendships
    my.resources :friendships, :as => 'friends', :collection => { :pending => :get }, :member => { :accept => :put, :reject => :delete }, :only => [ :index, :create, :destroy ], :paged => { :name => :directory }
    
    # Messages
    my.resources :sent_messages, :as => :sent, :only => [ :index, :show, :destroy ], :path_prefix => 'messages', :paged => { :name => :directory }
    my.resources :received_messages, :as => :messages, :only => [ :index, :show, :destroy ], :collection => { :unread => :get }, :member => { :reply => :get }, :paged => { :name => :directory }

    # Memberships
    my.resources :memberships, :as => 'groups', :collection => { :invited => :get }, :member => { :accept => :put, :reject => :delete }, :only => [ :index, :destroy ], :paged => { :name => :directory }

    # Default route
    my.root :controller => 'accounts', :action => 'show'
  end
  
  # community.clahrc.net
  map.subdomain :community, :name => nil do |community|
    community.resources :users, :as => :members, :only => [ :new, :edit, :create, :update ], :path_names => {  :new => 'register', :edit => 'activate' }
    community.resource :user_session, :as => :session, :only => [ :new, :create, :destroy ], :path_names => { :new => 'login' }
    community.resources :passwords, :only => [ :new, :edit, :create, :update ], :path_names => { :new => 'reset', :edit => 'reset' }
    
    # Members
    community.resources :members, :only => [ :index, :show ], :collection => { :autocomplete => :get }, :paged => { :name => :directory } do |member|
      # Activities
      member.resources :activities, :as => 'activity', :only => [ :index ], :paged => { :name => :directory }

      # Friendships
      member.resources :friendships, :as => 'friends', :only => [ :index, :create ], :paged => { :name => :directory }

      # Memberships
      member.resources :memberships, :as => 'groups', :only => [ :index ], :paged => { :name => :directory }

      # Messages
      member.resources :messages, :only => [ :new, :create ]

      # Assets
      member.resources :assets, :as => 'files', :only => [ :index ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }
      
      # Content
      member.resources :pages, :only => [ :index ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }
      member.resources :posts, :only => [ :index ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }
    end
    
    # Groups
    community.resources :groups, :paged => { :name => :directory } do |group|
      # Activitites
      group.resources :activities, :as => 'activity', :only => [ :index ], :paged => { :name => :directory }

      # Memberships
      group.resources :memberships, :as => 'members', :collection => { :pending => :get, :invite => :post }, :member => { :accept => :put, :promote => :put, :reject => :delete }, :only => [ :index, :new, :create ], :paged => { :name => :directory }
      group.resources :moderatorships, :as => 'moderators', :member => { :promote => :put }, :only => [ :index ], :paged => { :name => :directory }
      group.resources :ownerships, :as => 'owners', :only => [ :index ], :paged => { :name => :directory }

      # Messages
      group.resources :messages, :only => [ :new, :create ]
      
      # Assets
      group.resources :assets, :as => 'files', :only => [ :index, :new, :create ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }

      # Content
      group.resources :forums, :only => [ :index, :new, :create ], :paged => { :name => :directory }
      group.resources :pages, :only => [ :index, :new, :create ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }
    end

    # Assets
    community.resources :assets, :as => 'files', :only => [ :show, :edit, :update, :destroy ]
    
    # Forums
    community.resources :forums, :only => [ :show, :edit, :update, :destroy ] do |forum|
      forum.resources :topics, :only => [ :index, :new, :create ], :paged => { :name => :directory }
    end

    # Pages
    community.resources :pages, :only => [ :show, :edit, :update, :destroy ] do |page|
      page.resources :comments, :only => [ :index, :new, :create ], :paged => { :name => :directory }
    end
    
    # Posts
    community.resources :posts, :only => [ :show, :edit, :update, :destroy ] do |post|
      post.resources :comments, :only => [ :index, :new, :create ], :paged => { :name => :directory }
    end
    
    # Topics
    community.resources :topics, :only => [ :show, :edit, :update, :destroy ] do |topic|
      topic.resources :comments, :only => [ :index, :new, :create ], :paged => { :name => :directory }
    end
  
    # Search
    community.resources :search, :only => [ :index ], :collection => { :forums => :get, :groups => :get, :members => :get, :pages => :get, :posts => :get, :topics => :get }
  
    # Comments
    community.resources :comments, :only => [ :show, :edit, :update, :destroy ], :member => { :reply => :get }
    
    # Tags
    community.resources :tags, :only => [ :index, :show ]

    # Default route
    community.root :controller => 'members', :action => 'index'
  end
end
