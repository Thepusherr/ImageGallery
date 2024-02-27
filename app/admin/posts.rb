ActiveAdmin.register Post do
  # Specify parameters which should be permitted for assignment
  permit_params :title, :text, :image

  # or consider:
  #
  # permit_params do
  #   permitted = [:title, :text, :image]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :title
  filter :text
  filter :created_at
  filter :updated_at
  filter :image

  # Add or remove columns to toggle their visiblity in the index action
  index do
    selectable_column
    id_column
    column :title
    column :text
    column :created_at
    column :updated_at
    column :image
    actions
  end

  # Add or remove rows to toggle their visiblity in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :title
      row :text
      row :created_at
      row :updated_at
      row :image
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :title
      f.input :text
      f.input :image
    end
    f.actions
  end
end
