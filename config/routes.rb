Rails.application.routes.draw do
 
  #αρχική σελίδα
root "home#index"
 
 
  # Αυθεντικοποίηση με Devise και Google OAuth
  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' },
             path_names: { sign_in: 'login', sign_out: 'logout' }
 
  # Posts - CRUD
  resources :posts do
    #comments μέσα σε κάθε post
    resources :comments, only: [:create, :destroy]
  end
 
  #ιδιωτικές συνομιλίες
  namespace :private do
  resources :conversations, only: [:create] do
    member do
      post :open
      delete :close
    end
    #create στα messages
    resources :messages, only: [:index, :create]
  end
end
 
  #ομαδικές συνομιλίες
  namespace :group do
    resources :conversations, only: [:create, :update] do
      member do
        post :open
        delete :close
      end
      resources :messages, only: [:index, :create]
    end
  end
 
#ξεχωριστή σελίδα επαφών
resources :contacts, only: [:index, :create, :destroy]
 
#inbox
get '/conversations', to: 'conversations#index', as: :conversations
post '/conversations/:id/messages', to: 'conversations#create_message'
delete '/conversations/:id', to: 'conversations#destroy'
get '/conversations/:id', to: 'conversations#show', as: :conversation
get '/group_conversations/:id', to: 'conversations#show_group', as: :group_conv
delete '/group_conversations/:id', to: 'conversations#destroy_group'
 
end
