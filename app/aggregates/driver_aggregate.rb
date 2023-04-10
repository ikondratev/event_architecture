class DriverAggregate
  include AggregateRoot

  AlreadyOffered = Class.new(StandardError)
  NotAvailableToAccept = Class.new(StandardError)
  NotAvailableToReject = Class.new(StandardError)

  def initialize(id)
    @driver_id = id
    @state = :unknown
  end

  def offer_ride(ride)
    # TODO: compare params hash
    raise AlreadyOffered if @state == :considering

    apply RideOffered.new(data: { ride_id: ride.id, driver_id: @driver_id })
  end

  def accept_ride(ride, car_id)
    raise NotAvailableToAccept if @state != :considering

    apply RideAccepted.new(data: { ride_id: ride.id, driver_id: @driver_id, car_id: car_id })
  end

  def reject_ride(ride)
    raise NotAvailableToReject if @state != :on_a_way

    apply RideRejected.new(data: { ride_id: ride.id })
  end

  on RideOffered do |_event|
    @state = :considering
  end

  on RideAccepted do |_event|
    @state = :on_a_way
  end

  on RideRejected do |_event|
    @state = :considering
  end
end
