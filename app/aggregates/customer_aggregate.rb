class CustomerAggregate
  include AggregateRoot

  AlreadyRequested = Class.new(StandardError)

  def initialize(id)
    @id = id
    @state = :unknown
  end

  def request_ride(ride_id, _params)
    # TODO: compare params hash
    raise AlreadyRequested if @state == :waiting_car

    apply RideRequested.new(data: { ride_id: ride_id, customer_id: @id })
  end

  on RideRequested do |_event|
    @state = :waiting_car
  end
end
