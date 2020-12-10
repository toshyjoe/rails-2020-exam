Rails.application.routes.draw do
  root to: redirect('/products')
  get '/promo', to: 'products#index', promoted: true
  get '/tagged/:tag', to: 'products#index', as: :tagged
  resources :products
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
