Refinery::Application.routes.draw do
  scope(:path => 'refinery', :as => 'admin', :module => 'admin') do
    resources :memberships, :only => :index do
      collection do
        get :settings
        put :save_settings
      end
    end
    resources :roles 
    resources :members do
      member do
        put :extend
        
        put :enable
        put :disable
        
        put :accept
        put :reject
      end
    end
    resources :membership_emails, :except => :show do
      collection do
        get :settings
        put :save_settings
      end
    end
    resources :membership_email_parts, :except => :index
  end

  resource :members, :except => [:destroy] do
    get :login
		#match '/new/welcome' => 'members#welcome', :as => :welcome
		get :welcome
		get :new_password
		match '/new_password' => 'members#create_password', :as => :create_password
		match '/new_password/created' => 'members#new_password_created', :as => :new_password_created
    get :profile
    match '/activate/:confirmation_token' => 'members#activate', :as => :activate, :constraints => {:confirmation_token => /[a-zA-Z0-9]+/}, :via => :get
	end	
end
