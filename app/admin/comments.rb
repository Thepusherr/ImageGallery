ActiveAdmin.register Comment do
  # Specify parameters which should be permitted for assignment
  permit_params :post_id, :text, :user_id

  # or consider:
  #
  # permit_params do
  #   permitted = [:post_id, :text, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :post
  filter :text
  filter :created_at
  filter :updated_at
  filter :user

  # Add or remove columns to toggle their visiblity in the index action
  index do
    selectable_column
    id_column
    column :post
    column :text
    column :created_at
    column :updated_at
    column :user
    actions
  end

  # Add or remove rows to toggle their visiblity in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :post
      row :text
      row :created_at
      row :updated_at
      row :user
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :post
      f.input :text
      f.input :user
    end
    f.actions
  end
end
