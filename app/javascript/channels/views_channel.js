import consumer from "./consumer"

// Subscribe to views updates for a specific post
export function subscribeTo(postId) {
  return consumer.subscriptions.create(
    { channel: "ViewsChannel", post_id: postId },
    {
      connected() {
        console.log(`Connected to views for post ${postId}`)
      },

      disconnected() {
        console.log(`Disconnected from views for post ${postId}`)
      },

      received(data) {
        console.log("Received view update for post", postId, data)
        
        // Update actions (view count)
        if (data.actions_html) {
          const actionsElement = document.getElementById(`post${postId}actions`)
          if (actionsElement) {
            actionsElement.outerHTML = data.actions_html
            console.log("Updated view count")
          }
        }
      }
    }
  )
}
