Rails.application.routes.draw do
  root to: "pages#landing"
  devise_for :users
  resources :teachers
  resources :students
  resources :categories
  resources :courses

  post "link_course", to: "courses#link_course", :defaults => { :format => :json }
  post "unlink_course", to: "courses#unlink_course", :defaults => { :format => :json }
  get "course_codes", to: "courses#codes", :defaults => { :format => :json }
  get "show_tree", to: "students#show_tree", :defaults => { :format => :json }
  get "search_courses", to: "courses#search_courses", :defaults => { :format => :json }
end
