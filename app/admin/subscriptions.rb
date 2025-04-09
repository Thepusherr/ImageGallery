ActiveAdmin.register Subscription do
  permit_params :user_id, :category_id

  index do
    selectable_column
    id_column
    column :user
    column :category
    column :created_at
    actions
  end

  filter :user
  filter :category
  filter :created_at

  form do |f|
    f.inputs do
      f.input :user
      f.input :category
    end
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :category
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end