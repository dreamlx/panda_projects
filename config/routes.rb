Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  resources :users, only: [:index, :edit, :update, :show]
  resources :billings do
    resources :receive_amounts, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :clients do
    resources :contacts
  end
  resources :deductions
  resources :projects do
    post :close, on: :member
    resources :bookings
  end
  resources :dicts, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :industries
  resources :items
  resources :expenses, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :initialfees
  resources :personalcharges, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :reports do
    get :print, on: :collection
  end

  resources :time_reports do
    post :summary, on: :collection
    get   :summary_by_user, on: :collection
    post :time_report, on: :collection
  end
  resources :people
  resources :contacts, only: [:index, :create, :update] 
  resources :periods, only: [:index, :new, :create, :edit, :update]
  resources :prj_expense_logs, only: [:index, :destroy]
  resources :ufafees
end