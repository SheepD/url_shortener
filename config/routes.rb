Rails.application.routes.draw do
  root to: 'shortened_urls#new'

  resources :shortened_urls, only: [:new, :create]
  get ':slug' => 'shortened_urls#visit', as: 'visit_path'
end
