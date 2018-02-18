Rails.application.routes.draw do
  resources :tickets do
    member do
      put :do_return
      put :undo_return
      delete :submit_return
    end
    collection do
      get :to_return
    end
  end
  resources :users do
    member do
      post :add_money
      put :add_money
      put :sub_money
    end
  end
  root :to => "application#index"
  resources :events do
  end

  get 'session/login'
  get 'session/logout'
  post 'session/login_attempt'
  get 'users/tickets'

end

