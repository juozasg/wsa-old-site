MembersSite::Application.routes.draw do

  # This line mounts Refinery's routes at the root of your application.
  # This means, any requests to the root URL of your application will go to Refinery::PagesController#home.
  # If you would like to change where this extension is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Refinery relies on it being the default of "refinery"

  # sign_in_path is used by forem to force users to sign in
  match '/sign_in' => redirect('/refinery/login')
  resources :users, :only => 'show'


  mount Forem::Engine, :at => '/'
  mount Refinery::Core::Engine, :at => '/'
end