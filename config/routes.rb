Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations', 
  																	registrations: 'registrations',
  																	omniauth_callbacks: 'omniauth_callbacks' }
	root "main#index"
	
end
