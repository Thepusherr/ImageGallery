import consumer from "./consumer"

// Subscribe to comments updates for a specific post
export function subscribeTo(postId) {
  return consumer.subscriptions.create(
    { channel: "CommentsChannel", post_id: postId },
    {
      connected() {
        console.log(`Connected to comments for post ${postId}`)
      },

      disconnected() {
        console.log(`Disconnected from comments for post ${postId}`)
      },

      received(data) {
        console.log("Received comment update for post", postId, data)
        
        // Update comments section
        if (data.comments_html) {
          const commentsElement = document.getElementById(`post${postId}comments`)
          if (commentsElement) {
            commentsElement.outerHTML = data.comments_html
            console.log("Updated comments section")
          }
        }
        
        // Update actions (comment count)
        if (data.actions_html) {
          const actionsElement = document.getElementById(`post${postId}actions`)
          if (actionsElement) {
            actionsElement.outerHTML = data.actions_html
            console.log("Updated actions section")
          }
        }
      }
    }
  )
}
