import consumer from "./consumer"

// Subscribe to time updates for all posts
export function subscribeToTimeUpdates() {
  return consumer.subscriptions.create(
    { channel: "TimeUpdatesChannel" },
    {
      connected() {
        console.log("Connected to time updates channel")
      },

      disconnected() {
        console.log("Disconnected from time updates channel")
      },

      received(data) {
        console.log("Received time update", data)
        
        // Update time for specific post
        if (data.post_id && data.time_html) {
          const timeElement = document.getElementById(`post${data.post_id}time`)
          if (timeElement) {
            timeElement.outerHTML = data.time_html
            console.log(`Updated time for post ${data.post_id}`)
          }
        }
      }
    }
  )
}
