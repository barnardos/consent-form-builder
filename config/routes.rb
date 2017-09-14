Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'research_sessions#index'

  get '/start', to: 'research_sessions#start'

  resources :questions, only: [:show, :update], controller: 'research_sessions'

  get 'research-session/preview', to: 'research_sessions#preview'
  get '/gallery/', to: 'gallery#index'
end
