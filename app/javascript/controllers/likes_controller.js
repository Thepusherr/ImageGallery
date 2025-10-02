import { Controller } from "@hotwired/stimulus"
import { subscribeTo as subscribeToLikes } from "../channels/likes_channel"
import { subscribeTo as subscribeToComments } from "../channels/comments_channel"

export default class extends Controller {
  static values = { postId: Number }

  connect() {
    console.log("Post controller connected!")
    console.log("Post ID:", this.postIdValue)

    if (this.postIdValue) {
      console.log("Connecting to channels for post", this.postIdValue)
      this.likesSubscription = subscribeToLikes(this.postIdValue)
      this.commentsSubscription = subscribeToComments(this.postIdValue)
    } else {
      console.log("No post ID found!")
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
  }
}
