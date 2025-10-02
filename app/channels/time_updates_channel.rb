class TimeUpdatesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "time_updates"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
