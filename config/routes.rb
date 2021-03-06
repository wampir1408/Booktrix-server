Rails.application.routes.draw do


  namespace :api, defaults: { format: :json }, path: '/api/' do
    scope module: :v1 do
      resources :users, :only => [:show, :create, :update, :destroy]
      resources :sessions, :only => [:create, :destroy]
      resources :friends, :only => [:index, :create, :show]
      patch 'friends' => 'friends#update'
      delete 'friends' => 'friends#destroy'
      resources :categories, :only => [:index, :show, :create, :update, :destroy]
      resources :book_list_states, :only => [:index]
      resources :borrow_history_states, :only => [:index]
      resources :books, :only => [:index, :show]
      get 'found_by_isbn' => 'books#found_by_isbn'
      resources :request_to_fixes, :only => [:create]
      resources :gifts, :only => [:index, :show, :create, :destroy]
      resources :reservations, :only => [:index, :create, :destroy]
      resources :book_lists, :only => [:index, :create, :update, :destroy]
      resources :user_books, :only => [:index, :show, :create, :update, :destroy]
      resources :borrows, :only => [:create, :destroy]
      resources :borrow_histories, :only => [:index]
      resources :marks, :only => [:create, :update, :destroy]
      resources :activities, :only => [:index]
      resources :likes, :only => [:create, :destroy]
      resources :post_comments, :only => [:index, :create, :update, :destroy]
    end
  end

  devise_for :users
end
