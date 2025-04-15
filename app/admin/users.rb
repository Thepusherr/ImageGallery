ActiveAdmin.register User do
  # Use friendly_id in ActiveAdmin
  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      scoped_collection.find(params[:id])
    end
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :surname, :avatar, :slug, :username
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :name, :surname, :avatar, :slug, :username]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  remove_filter :avatar_attachment, :avatar_blob
  

  permit_params :email, :password, :password_confirmation, :name, :surname, :username

  index do
    selectable_column
    id_column
    column :name
    column :surname
    column :email
    column :current_sign_in_at
    #column :sign_in_count
    column :created_at
    actions
  end

  filter :name
  filter :surname
  filter :email
  filter :current_sign_in_at
  #filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :surname
      f.input :username
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
