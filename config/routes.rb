Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'meeting', to: 'meeting#create', as: 'bigbluebutton_join'

  post 'meeting/create_new_room', to: 'meeting#createNewRoom', as: 'new_room'
  # Defines the root path route ("/")
  # root "posts#index"

  get 'meeting/list_recordings', to: 'meeting#list_recordings', as: 'list_recordings'

  delete 'meeting/delete_recording', to: 'meeting#delete_recording', as: 'delete_recording'

  root 'meeting#create'
end
