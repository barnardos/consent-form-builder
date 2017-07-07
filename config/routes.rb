Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  # NB: the below is not totally idiomatic Rails routing, but I wanted
  # to ape the express.js version as closely as possible by way of example.
  # Usually you might say # resources :questions, only: [:show, :create],
  # but the created routes/verbs # don't match the JS completely.
  # So I've gone for get = #show and post = #create, which is close to normal
  # +resources+ semantics.
  get '/start', to: 'questions#start'

  get '/questions/:id', to: 'questions#show', as: 'question'
  post '/questions/:id', to: 'questions#create'

  get '/gallery/', to: 'gallery#index'

end
