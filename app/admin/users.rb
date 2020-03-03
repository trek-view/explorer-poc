ActiveAdmin.register User do
  config.per_page = 50

  permit_params :name, :email, :password, :password_confirmation, :enabled_apikey

  before_action only: %i[show edit update destroy] do
    @user = User.find_by_slug(params[:id])
  end

  controller do
    def update
      previous_enabled_apikey = @user.enabled_apikey
      if user_params[:password].blank?
        @user.update_without_password(user_params)
      else
        @user.update_attributes(user_params)
      end

      enabled_apikey = user_params[:enabled_apikey]
      if !previous_enabled_apikey && (enabled_apikey.present? && enabled_apikey == "1")
        # Send email notification for enabled
        puts "===== Send email notification for enabled"
        AdminMailer.with(user: @user).notify_api_key_enabled_to_user.deliver_now
      elsif previous_enabled_apikey && (enabled_apikey.present? && enabled_apikey == "0")
        # Send email notification for disabled
        puts "===== Send email notification for disabled"
        AdminMailer.with(user: @user).notify_api_key_disabled_to_user.deliver_now
      end

      if @user.errors.blank?
        redirect_to admin_users_path, notice: 'User updated successfully.'
      else
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(
        :name, :email, :password, :password_confirmation, :enabled_apikey
      )
    end
  end

  index do
    selectable_column
    column :email
    column :name
    column :created_at
    column :last_sign_in_at
    column :tours_count
    column :tourbooks_count
    column :enabled_apikey

    actions defaults: false do |user|
      item "View", admin_user_path(user), class: 'member_link'
      item "Edit", edit_admin_user_path(user)
    end
  end

  show do
    attributes_table do
      row :email
      row :name
      row :created_at
      row :last_sign_in_at
      row :tours_count
      row :tourbooks_count
      row :enabled_apikey
    end
  end

  form do |f|
    f.semantic_errors
    inputs :email, :name, :password, :password_confirmation, :enabled_apikey
    f.actions
  end
end
