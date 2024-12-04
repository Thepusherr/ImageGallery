# frozen_string_literal: true
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    div class: "px-4 py-16 md:py-32 text-center m-auto max-w-3xl" do
      h2 "Last 5 categories", class: "text-base font-semibold leading-7 text-indigo-600 dark:text-indigo-500"

      h2 "Last 5 comments", class: "text-base font-semibold leading-7 text-indigo-600 dark:text-indigo-500"

      h2 "Last 10 images", class: "text-base font-semibold leading-7 text-indigo-600 dark:text-indigo-500"

      h2 "user actions", class: "text-base font-semibold leading-7 text-indigo-600 dark:text-indigo-500"


      para "user navigation", class: "mt-2 text-3xl sm:text-4xl font-bold text-gray-900 dark:text-gray-200"

      para "user login time", class: "mt-2 text-3xl sm:text-4xl font-bold text-gray-900 dark:text-gray-200"

      para "user logout time", class: "mt-2 text-3xl sm:text-4xl font-bold text-gray-900 dark:text-gray-200"

      para "user logout time", class: "mt-2 text-3xl sm:text-4xl font-bold text-gray-900 dark:text-gray-200"

      # para class: "mt-6 text-xl leading-8 text-gray-700 dark:text-gray-400" do
      #   text_node "To update the content, edit the"
      #   strong "app/admin/dashboard.rb"
      #   text_node "file to get started."
      # end

      section "Your tasks for this week" do
        table_for current_admin_user.tasks.where('due_date > ? and due_date < ?', Time.now, 1.week.from_now) do |t|
          t.column("Status") { |task| status_tag (task.is_done ? "Done" : "Pending"), (task.is_done ? :ok : :error) }
          t.column("Title") { |task| link_to task.title, admin_task_path(task) }
          t.column("Assigned To") { |task| task.admin_user.email }
          t.column("Due Date") { |task| task.due_date? ? l(task.due_date, :format => :long) : '-' }
        end
      end
     
      section "Tasks that are late" do
        table_for current_admin_user.tasks.where('due_date < ?', Time.now) do |t|
          t.column("Status") { |task| status_tag (task.is_done ? "Done" : "Pending"), (task.is_done ? :ok : :error) }
          t.column("Title") { |task| link_to task.title, admin_task_path(task) }
          t.column("Assigned To") { |task| task.admin_user.email }
          t.column("Due Date") { |task| task.due_date? ? l(task.due_date, :format => :long) : '-' }
        end
      end
    end
  end
end
