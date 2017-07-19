Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'research_sessions#index'

  # NB: the below is not totally idiomatic Rails routing, but I wanted
  # to ape the express.js version as closely as possible by way of example.
  # Usually you might say # resources :research_sessions, only: [:show, :create],
  # but the created routes/verbs # don't match the JS completely.
  # So I've gone for get = #show and post = #create, which is close to normal
  # +resources+ semantics.
  get '/start', to: 'research_sessions#start'

  get '/research_sessions/:id', to: 'research_sessions#show', as: 'question'
  post '/research_sessions/:id', to: 'research_sessions#create'

  get '/gallery/', to: 'gallery#index'

end
