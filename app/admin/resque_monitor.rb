# frozen_string_literal: true

ActiveAdmin.register_page "Resque Monitor" do
  menu priority: 8, label: "Background Jobs"

  content title: "Background Jobs Monitor" do
    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span "Resque Background Jobs Status"
        small "Monitor and manage background job queues"
      end
    end

    columns do
      column do
        panel "Queue Statistics" do
          begin
            div do
              h3 "Redis Connection: #{Resque.redis.connected? ? '✅ Connected' : '❌ Disconnected'}"
            end
            
            div do
              h4 "Queues:"
              ul do
                Resque.queues.each do |queue|
                  li "#{queue}: #{Resque.size(queue)} jobs"
                end
              end
            end

            div do
              h4 "Workers:"
              workers = Resque.workers
              if workers.any?
                ul do
                  workers.each do |worker|
                    li "#{worker}: #{worker.state}"
                  end
                end
              else
                p "No workers running"
              end
            end

            div do
              h4 "Failed Jobs: #{Resque::Failure.count}"
            end

          rescue => e
            div do
              h3 "❌ Redis Error: #{e.message}"
              p "Make sure Redis server is running: redis-server"
            end
          end
        end
      end

      column do
        panel "Recent Jobs" do
          begin
            div do
              h4 "Jobs in Default Queue:"
              jobs = Resque.peek(:default, 0, 10)
              if jobs.any?
                table_for jobs do
                  column("Class") { |job| job['class'] }
                  column("Arguments") { |job| job['args'].inspect }
                end
              else
                p "No jobs in queue"
              end
            end

            div do
              h4 "Failed Jobs:"
              failed_jobs = (0...[Resque::Failure.count, 5].min).map { |i| Resque::Failure.all(i) }
              if failed_jobs.any?
                table_for failed_jobs do
                  column("Class") { |job| job['payload']['class'] }
                  column("Error") { |job| job['error'] }
                  column("Failed At") { |job| job['failed_at'] }
                end
              else
                p "No failed jobs"
              end
            end

          rescue => e
            div do
              p "Error loading job details: #{e.message}"
            end
          end
        end
      end
    end

    div do
      h3 "Commands"
      ul do
        li "Start worker: QUEUE=* bundle exec rake resque:work"
        li "Clear all queues: bundle exec rake resque:clear"
        li "Clear failed jobs: Resque::Failure.clear"
      end
    end
  end
end
