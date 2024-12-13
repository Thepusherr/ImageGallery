# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "px-4 py-16 md:py-32 text-center m-auto max-w-3xl" do
      # para class: "mt-6 text-xl leading-8 text-gray-700 dark:text-gray-400" do
      #   text_node "To update the content, edit the"
      #   strong "app/admin/dashboard.rb"
      #   text_node "file to get started."
      # end

      h2 "Last 5 categories", class: "text-base font-semibold leading-7 text-indigo-600 dark:text-indigo-500" do
        table_for Category.last(5) do |c|
          c.column("name") { |category| category.name }
          c.column("user_id") { |category| category.user_id }
          c.column("created_at") { |category| category.updated_at? ? l(category.created_at, :format => :long) : '-' }
          c.column("updated_at") { |category| category.created_at? ? l(category.updated_at, :format => :long) : '-' }
        end
      end

      h2 "Last 5 comments", class: "text-base font-semibold leading-7 text-indigo-600 dark:text-indigo-500" do
        table_for Comment.last(5) do |c|
          c.column("text") { |comment| comment.text }
          c.column("user_id") { |comment| comment.user_id }
          c.column("post_id") { |comment| comment.post_id }
          c.column("created_at") { |comment| comment.updated_at? ? l(comment.created_at, :format => :long) : '-' }
          c.column("updated_at") { |comment| comment.created_at? ? l(comment.updated_at, :format => :long) : '-' }
        end
      end

      h2 "Last 10 images", class: "text-base font-semibold leading-7 text-indigo-600 dark:text-indigo-500"

      h2 "user actions", class: "text-base font-semibold leading-7 text-indigo-600 dark:text-indigo-500" do
        all_actions = []

        User.all.map do |user|
          all_actions << { user: user.email, action: user.last_sign_in_at, url: "#{root_url}/login", timestamp: user.last_sign_in_at }
        end
        
        table_for User.all do |u|
          u.column("user") { |user| user.email }
          u.column("action") { |user| user }
          u.column("URL") { |user| user.post_id }
          #u.column("created_at") { |user| user.updated_at? ? l(user.created_at, :format => :long) : '-' }
          u.column("Timestamp") { |user| user.created_at? ? l(user.updated_at, :format => :long) : '-' }
        end
      end

      para "user navigation", class: "mt-2 text-3xl sm:text-4xl font-bold text-gray-900 dark:text-gray-200"

      para "user login time", class: "mt-2 text-3xl sm:text-4xl font-bold text-gray-900 dark:text-gray-200"

      para "user logout time", class: "mt-2 text-3xl sm:text-4xl font-bold text-gray-900 dark:text-gray-200"

      para "user logout time", class: "mt-2 text-3xl sm:text-4xl font-bold text-gray-900 dark:text-gray-200"
     
      # section "Tasks that are late" do
      #   table_for current_admin_user.tasks.where('due_date < ?', Time.now) do |t|
      #     t.column("Status") { |task| status_tag (task.is_done ? "Done" : "Pending"), (task.is_done ? :ok : :error) }
      #     t.column("Title") { |task| link_to task.title, admin_task_path(task) }
      #     t.column("Assigned To") { |task| task.admin_user.email }
      #     t.column("Due Date") { |task| task.due_date? ? l(task.due_date, :format => :long) : '-' }
      #   end
      # end
    end
  end
end
