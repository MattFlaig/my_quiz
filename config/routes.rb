MyQuiz::Application.routes.draw do

  root to: 'quizzes#index'

  resources :questions do
    get 'set_correct_answer', :on => :member, :as => 'set_correct_answer'
    get 'set_incorrect_answer', :on => :member, :as => 'set_incorrect_answer'
    resources :answers, only: [:create, :new, :destroy]
  end

  resources :categories, only: [:new, :create]
  resources :users, only:[:new, :create, :show]

  resources :quizzes do
    resources :reviews, only: [:create]
  end
  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  get 'start_quiz/:id', to: 'take_quizzes#start', as: 'start_quiz'
  get "take_quiz/:id/:current_question/:number", to: 'take_quizzes#question', as: 'take_quiz'
  post 'answer/:id/:current_question', to: 'take_quizzes#answer', as: 'answer_question'
  get 'score/:id', to: 'take_quizzes#score', as: 'score'

  get 'help', to: 'quizzes#help'
  get 'survey/:id', to: 'take_quizzes#survey'
  #get 'update/:id', to: 'quizzes#update'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
