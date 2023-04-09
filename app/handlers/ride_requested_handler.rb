class RideRequestedHandler
  def initialize(event_store)
    @event_store = event_store
  end

  def call(event)
    with_free_driver(event.data) do |driver_id|
      ride_id = event.data[:ride_id]
      @event_store.publish(
        RideOffered.new(data: { ride_id: ride_id, driver_id: driver_id }),
        stream_name: "ride$#{ride_id}"
      )
    end
  end

  def with_free_driver(_params)
    # use service for find driver
    # for testing we use stub
    yield '03a0c302-6c7b-4d34-a3da-a4125d5a5fcd'
  end
end