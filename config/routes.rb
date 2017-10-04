Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'research_sessions#index'

  resources :research_sessions, only: [:show, :create], path: 'research-sessions' do
    resources :questions, only: [:show, :update], controller: 'research_sessions'
    get :preview
  end

  get '/gallery/', to: 'gallery#index'
  resource :changelog
end
