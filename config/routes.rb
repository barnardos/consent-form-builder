Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'start_pages#show'

  resources :research_sessions, only: [:new, :create], path: 'research-sessions' do
    resources :questions, only: [:show, :update], controller: 'research_sessions/questions'
    get :preview
    post :create_a_copy
  end

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all

  get '*url' => 'errors#not_found'
end
