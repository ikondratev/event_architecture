class RideRequestedHandler < ApplicationJob
  prepend RailsEventStore::AsyncHandler

  def perform(event)
    with_free_driver(event.data) do |driver_id|
      ride_id = event.data[:ride_id]
      Rails.configuration.event_store.with_metadata(ride_id: ride_id) do
        DriverRepository.new.with_driver(driver_id) do |driver|
          driver.offer_ride(Ride.find(ride_id))
        end
      end
    end
  end

  def with_free_driver(_params)
    # use service for find driver
    # for testing we use stub
    yield '03a0c302-6c7b-4d34-a3da-a4125d5a5fcd'
  end
end