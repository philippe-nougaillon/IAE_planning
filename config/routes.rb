Rails.application.routes.draw do
  
  resources :import_logs do
    member do
      get 'download_imported_file'
    end
  end

  resources :etudiants
  
  get 'tools/index'
  get 'tools/import'
  post 'tools/import_do'
  get 'tools/creation_cours'
  post 'tools/creation_cours_do'
  get 'tools/import_intervenants'
  post 'tools/import_intervenants_do'
  get 'tools/import_utilisateurs'
  post 'tools/import_utilisateurs_do'
  get 'tools/export'
  post 'tools/export_do'
  get 'tools/export_intervenants'
  post 'tools/export_intervenants_do'
  get 'tools/swap_intervenant'
  post 'tools/swap_intervenant_do'
  get 'tools/etats_services'
  get 'tools/audits'
  get 'tools/import_etudiants'
  post 'tools/import_etudiants_do'
  get 'tools/export_etudiants'
  post 'tools/export_etudiants_do'
  get 'tools/taux_occupation_jours'
  post 'tools/taux_occupation_jours_do'
  get 'tools/taux_occupation_salles'
  post 'tools/taux_occupation_salles_do'

  get 'tools/nouvelle_saison'
  post 'tools/nouvelle_saison_create'

  get 'salles/occupation'
  get 'salles/occupation', as: :occupation_des_salles

  get 'cours/index_slide' # à supprimer 
  get 'cours/planning' => "cours#index_slide"

  post 'cours/action'
  post 'cours/action_do'

  devise_for :users
  
  resources :documents
  resources :cours
  resources :salles
  resources :formations
  resources :intervenants
  resources :users
  resources :fermetures
  
  namespace :api, defaults: {format: 'json'} do 
    namespace :v1 do 
        resources :cours
    end 
  end 

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'cours#index'

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
