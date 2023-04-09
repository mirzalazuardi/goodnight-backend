Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'users', to: 'users#create'
      post 'follow', to: 'users#follow'
      post 'unfollow', to: 'users#unfollow'
      post 'sleep-records', to: 'users#sleep_records'
      get 'sleep-records', to: 'users#display_sleep_records',
        as: :display_sleep_records
      get 'friends-sleep-records', to: 'users#friends_sleep_records'
    end
  end
end
