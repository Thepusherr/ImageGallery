import { Controller } from "@hotwired/stimulus"
import { subscribeTo as subscribeToLikes } from "../channels/likes_channel"
import { subscribeTo as subscribeToComments } from "../channels/comments_channel"
import { subscribeTo as subscribeToViews } from "../channels/views_channel"
import { subscribeToTimeUpdates } from "../channels/time_updates_channel"

export default class extends Controller {
  static values = { postId: Number }

  connect() {
    console.log("Post controller connected!")
    console.log("Post ID:", this.postIdValue)

    if (this.postIdValue) {
      console.log("Connecting to all channels for post", this.postIdValue)
      this.likesSubscription = subscribeToLikes(this.postIdValue)
      this.commentsSubscription = subscribeToComments(this.postIdValue)
      this.viewsSubscription = subscribeToViews(this.postIdValue)

      // Set up intersection observer to track when post becomes visible
      this.setupViewTracking()
    } else {
      console.log("No post ID found!")
    }

    // Subscribe to time updates (only once per page, not per post)
    if (!window.timeUpdatesSubscription) {
      window.timeUpdatesSubscription = subscribeToTimeUpdates()
      console.log("Subscribed to time updates")
    }
  }

  disconnect() {
    console.log("Post controller disconnected")
    if (this.likesSubscription) {
      this.likesSubscription.unsubscribe()
    }
    if (this.commentsSubscription) {
      this.commentsSubscription.unsubscribe()
    }
    if (this.viewsSubscription) {
      this.viewsSubscription.unsubscribe()
    }
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  setupViewTracking() {
    // Only track if user is signed in
    const isSignedIn = document.querySelector('meta[name="user-signed-in"]')?.content === 'true'
    if (!isSignedIn) return

    // Create intersection observer to track when post becomes visible
    this.observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting && !this.hasBeenViewed) {
          console.log(`Post ${this.postIdValue} became visible, tracking view`)
          this.trackView()
          this.hasBeenViewed = true
        }
      })
    }, {
      threshold: 0.5, // Trigger when 50% of post is visible
      rootMargin: '0px'
    })

    // Start observing this post element
    this.observer.observe(this.element)
  }

  trackView() {
    // Send AJAX request to track the view
    fetch('/posts/track_view', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        post_id: this.postIdValue
      })
    })
    .then(response => {
      if (response.ok) {
        console.log(`View tracked for post ${this.postIdValue}`)
      }
    })
    .catch(error => {
      console.error('Error tracking view:', error)
    })
  }
}
