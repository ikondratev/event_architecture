class RidesController < ApplicationController
  def create
    current_user.with_lock do
      ride_id = SecureRandom.uuid
      event_store.with_metadata(ride_id: ride_id) do
        CustomerRepository.new.with_customer(current_user.id) do |customer|
          customer.request_ride(ride_id, params)
        end
      end
    end
  end

  def accept
    current_driver.with_lock do
      ride_id = params[:ride_id]
      event_store.with_metadata(ride_id: ride_id) do
        DriverRepository.new.with_driver(current_driver.id) do |driver|
          driver.accept_ride(Ride.find(ride_id), current_driver.car.id)
        end
      end
    end
  end

  def reject

  end
end
