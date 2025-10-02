import consumer from "./consumer"

// Subscribe to likes updates for a specific post
export function subscribeTo(postId) {
  return consumer.subscriptions.create(
    { channel: "LikesChannel", post_id: postId },
    {
      connected() {
        console.log(`Connected to likes for post ${postId}`)
      },

      disconnected() {
        console.log(`Disconnected from likes for post ${postId}`)
      },

      received(data) {
        console.log("Received like update for post", postId, data)
        // Update the post actions when someone likes/unlikes
        const actionsElement = document.getElementById(`post${postId}actions`)
        console.log("Found actions element:", actionsElement)
        if (actionsElement && data.html) {
          actionsElement.outerHTML = data.html
          console.log("Updated post actions")
        } else {
          console.log("Actions element not found or no HTML data")
        }
      }
    }
  )
}
