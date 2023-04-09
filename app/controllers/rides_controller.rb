class RidesController < ApplicationController
  def create
    current_user.with_lock do
      ride_id = SecureRandom.uuid
      event_store.publish(
        RideRequested.new(data: { ride_id: ride_id, customer_id: current_user.id }),
        stream_name: "ride$#{ride_id}"
      )
    end
  end
end
