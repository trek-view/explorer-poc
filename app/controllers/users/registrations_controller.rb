class Users::RegistrationsController < Devise::RegistrationsController
  # DELETE /resource
  # def destroy
  #   @user = User.find(current_user.id)
  #   if @user.destroy_with_password(user_params)
  #     redirect_to root_url, notice: "User deleted."
  #   else
  #     redirect_to users_url
  #     flash[:notice] = "Couldn't delete"
  #   end
  #
  #   resource.soft_delete
  #   Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
  #   set_flash_message :notice, :destroyed
  #   yield resource if block_given?
  #   respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  # end
end