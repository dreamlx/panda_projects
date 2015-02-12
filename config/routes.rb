Rails.application.routes.draw do
  root 'welcome#index'
  resources :users do
    get :login, on: :collection
    post :login, on: :collection
    post :logout, on: :collection
  end

  resources :billings do
    resources :receive_amounts, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :clients
  resources :deductions
  resources :projects do
    post :close, on: :member
  end
  resources :dicts, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :industries
  resources :items
  resources :expenses
  resources :initialfees
  resources :personalcharges
  resources :reports do
    get :print, on: :collection
    post :summary, on: :collection
    get :summary_by_user, on: :collection
    post :time_report, on: :collection
  end
  resources :people
  resources :periods
  resources :prj_expense_logs, only: [:index, :destroy]
  resources :ufafees
end