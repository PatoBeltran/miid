Rails.application.routes.draw do
  root to: "pages#landing"
  devise_for :users
  resources :teachers
  resources :students
  resources :categories
  resources :courses

  post "link_course", to: "courses#link_course"
end
