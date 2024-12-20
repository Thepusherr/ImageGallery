ActiveAdmin.register UserEvent do
  actions :index, :show

  filter :user
  filter :action_type, as: :select, collection: %w[navigation user_sign_in user_sign_out liked unliked commented]
  filter :url
  filter :timestamp

  index do
    selectable_column
    id_column
    column :user
    column :action_type
    column :url do |event|
      link_to event.url, event.url, target: '_blank'
    end
    column :timestamp
    actions
  end

  show do
    attributes_table do
      row :user
      row :action_type
      row :url do |event|
        link_to event.url, event.url, target: '_blank'
      end
      row :timestamp
    end
  end
end
