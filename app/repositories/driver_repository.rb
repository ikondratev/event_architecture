class DriverRepository
  def initialize(event_store = Rails.configuration.event_store)
    @repository = AggregateRoot::Repository.new(event_store)
  end

  def with_driver(driver_id, &block)
    stream_name = "driver#{driver_id}"
    @repository.with_aggregate(DriverAggregate.new(driver_id), stream_name, &block)
  end
end