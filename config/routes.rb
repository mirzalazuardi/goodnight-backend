Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'users', to: 'users#create'
      post 'follow', to: 'users#follow', as: :follow
    end
  end
end
