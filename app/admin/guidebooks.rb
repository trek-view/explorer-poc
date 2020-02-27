ActiveAdmin.register Guidebook do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :description, :category_id, :user_id, :app
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :category_id, :user_id, :app]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
