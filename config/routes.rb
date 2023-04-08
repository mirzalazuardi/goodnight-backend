Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'users', to: 'users#create'
      post 'follow', to: 'users#follow'
      post 'unfollow', to: 'users#unfollow'
      post 'sleep-records', to: 'users#sleep_records'
    end
  end
end
