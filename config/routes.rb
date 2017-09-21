SolidusStripeSources::Engine.routes.draw do
  resources :returns, only: :show
  resources :redirects, only: [:show, :create]
  resources :webhooks do
    post :stripe, on: :collection
  end
end
