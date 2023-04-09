class RideModelHandler
  def call(event)
    case event
    when RideRequested
      Ride.create(id: event.data[:ride_id], user_id: event.data[:customer_id])
    when RideAccepted
      Ride.find(event.data[:ride_id]).update(
        driver_id: event.data[:driver_id],
        car_id: event.data[:car_id]
      )
    end
  end
end