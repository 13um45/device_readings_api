class ReadingsController < ApplicationController
  def create
    readings_params = params.permit(:id, readings: [:timestamp, :count])
    readings = readings_params[:readings].map {|reading| reading.to_h}

    cache_readings_data(readings_params[:id], readings)

    head :created
  end

  def latest_timestamp
    latest_reading = cached_latest_reading(params[:id])

    return head :not_found unless latest_reading

    render json: { latest_timestamp: latest_reading['timestamp'] }
  end

  def cumulative_count
    cumulative_count = cached_cumulative_count(params[:id])

    return head :not_found unless cumulative_count

    render json: { cumulative_count: cumulative_count }
  end

  private

  def cache_readings_data(device_id, readings)
    device_cache_key = "device_#{device_id}"
    existing_readings = Rails.cache.read(device_cache_key) || []

    # Filter out duplicate readings
    new_readings = readings.reject { |reading| existing_readings.any? { |r| r['timestamp'] == reading['timestamp'] } }
    Rails.cache.write(device_cache_key, existing_readings.concat(new_readings))
  end

  def cached_latest_reading(device_id)
    readings = Rails.cache.read("device_#{device_id}")

    return nil unless readings

    latest_reading = readings.max_by { |reading| DateTime.parse(reading['timestamp']) }

    return nil unless latest_reading

    latest_reading
  end

  def cached_cumulative_count(device_id)
    readings = Rails.cache.read("device_#{device_id}")

    return nil unless readings

    readings.sum { |reading| reading['count'].to_i }
  end
end
