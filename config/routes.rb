Rails.application.routes.draw do
  devise_scope :user do
    root to: "devise/sessions#new"
  end
  devise_for :users
  resources :teachers
  resources :students
  resources :categories
  resources :courses
end
