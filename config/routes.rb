Clahrc::Application.routes.draw do |map|
  constraints CommunitySubdomain do
    resources :users, :as => :members, :only => [ :new, :edit, :create, :update ], :path_names => {  :new => 'register', :edit => 'activate' }
    resource :user_session, :as => :session, :only => [ :new, :create, :destroy ], :path_names => { :new => 'login' }
    resources :passwords, :only => [ :new, :edit, :create, :update ], :path_names => { :new => 'reset', :edit => 'reset' }

    # Members
    resources :members, :only => [ :index, :show ], :collection => { :autocomplete => :get }, :paged => { :name => :directory } do
      # Activities
      resources :activities, :as => 'activity', :only => [ :index ], :paged => { :name => :directory }

      # Friendships
      resources :friendships, :as => 'friends', :only => [ :index, :create ], :paged => { :name => :directory }

      # Memberships
      resources :memberships, :as => 'groups', :only => [ :index ], :paged => { :name => :directory }

      # Messages
      resources :messages, :only => [ :new, :create ]

      # Assets
      resources :assets, :as => 'files', :only => [ :index ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }

      # Content
      resources :pages, :only => [ :index ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }
      resources :posts, :only => [ :index ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }
      resources :wiki_pages, :as => :wiki, :only => [ :index, :show ]
    end

    # Groups
    resources :groups, :paged => { :name => :directory } do
      # Activitites
      resources :activities, :as => 'activity', :only => [ :index ], :paged => { :name => :directory }

      # Memberships
      resources :memberships, :as => 'members', :collection => { :pending => :get, :invite => :post }, :member => { :accept => :put, :promote => :put, :reject => :delete }, :only => [ :index, :new, :create ], :paged => { :name => :directory }
      resources :moderatorships, :as => 'moderators', :member => { :promote => :put }, :only => [ :index ], :paged => { :name => :directory }
      resources :ownerships, :as => 'owners', :only => [ :index ], :paged => { :name => :directory }

      # Messages
      resources :messages, :only => [ :new, :create ]

      # Assets
      resources :assets, :as => 'files', :only => [ :index, :new, :create ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }

      # Content
      resources :forums, :only => [ :index, :new, :create ], :paged => { :name => :directory }
      resources :pages, :only => [ :index, :new, :create ], :collection => { :block => :get }, :paged => { :name => :directory, :index => true }
      resources :wiki_pages, :as => :wiki
    end

    # Assets
    resources :assets, :as => 'files', :only => [ :show, :edit, :update, :destroy ]

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
    resources :search, :only => [ :index ], :collection => { :forums => :get, :groups => :get, :members => :get, :pages => :get, :posts => :get, :topics => :get, :wiki_pages => :get }

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
      my.resources :activities, :as => 'activity', :only => [ :index ], :paged => { :name => :directory }

      # Assets
      my.resources :assets, :as => 'files', :paged => { :name => :directory }

      # Content
      my.resources :pages, :collection => { :sort => :put }, :paged => { :name => :directory }
      my.resources :posts, :paged => { :name => :directory }
      my.resources :wiki_pages, :as => :wiki

      # Friendships
      my.resources :friendships, :as => 'friends', :collection => { :pending => :get }, :member => { :accept => :put, :reject => :delete }, :only => [ :index, :create, :destroy ], :paged => { :name => :directory }

      # Messages
      my.resources :sent_messages, :as => :sent, :only => [ :index, :show, :destroy ], :path_prefix => 'messages', :paged => { :name => :directory }
      my.resources :received_messages, :as => :messages, :only => [ :index, :show, :destroy ], :collection => { :unread => :get }, :member => { :reply => :get }, :paged => { :name => :directory }

      # Memberships
      my.resources :memberships, :as => 'groups', :collection => { :invited => :get }, :member => { :accept => :put, :reject => :delete }, :only => [ :index, :destroy ], :paged => { :name => :directory }
    end
  end
end
