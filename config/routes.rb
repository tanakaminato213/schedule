Rails.application.routes.draw do
  root 'plans#index'
  get 'plans/index'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
