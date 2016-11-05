Rails.application.routes.draw do
  devise_for :users, controllers: { confirmations: 'confirmations', 
  																	registrations: 'registrations',
  																	omniauth_callbacks: 'omniauth_callbacks' }
	root "main#index"
	get "/:id" => "chat_rooms#show", as: :chat_room
	resources :chat_rooms, only: :create do 
		resources :messages, only: :create
	end
	get "*path", :to => redirect('/')

end
