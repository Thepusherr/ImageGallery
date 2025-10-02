class TimeUpdateJob < ApplicationJob
  queue_as :default

  def perform
    # Get all posts that are currently visible (created in last 24 hours)
    recent_posts = Post.where('created_at > ?', 24.hours.ago)
    
    recent_posts.find_each do |post|
      # Broadcast time update for each post
      ActionCable.server.broadcast("time_updates", {
        post_id: post.id,
        time_html: ApplicationController.render(
          partial: "posts/post_time",
          locals: { post: post }
        )
      })
    end
    
    Rails.logger.info "Time updates broadcasted for #{recent_posts.count} posts"
  end
end
