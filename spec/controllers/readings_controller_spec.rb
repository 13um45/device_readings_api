require 'rails_helper'

RSpec.describe "ReadingsController", type: :request do
  let(:readings) do
    {
      "id": "36d5658a-6908-479e-887e-a949ec199272",
      "readings" => [{
        "timestamp": "2021-09-29T16:08:15+01:00",
        "count" => 2
      }, {
        "timestamp": "2021-09-29T16:09:15+01:00",
        "count" => 15 }
      ] }
  end

  before :each do
    Rails.cache.clear
  end

  after :each do
    Rails.cache.clear
  end

  describe "POST /create" do
    context "when there are no duplicate readings" do
      it "caches the readings supplied by device id" do
        post "/readings/create", params: readings
        expect(response).to have_http_status(:created)
      end
    end

    context "when there are duplicate readings" do
      it "does not re-create them" do
        post "/readings/create", params: readings
        post "/readings/create", params: readings

        readings = Rails.cache.read("device_36d5658a-6908-479e-887e-a949ec199272")

        expect(readings.count).to eq(2)
      end
    end

    context "when the data is malformed" do

    end
  end

  describe "GET /latest_timestamp" do
    context "when device readings exist" do
      it "gets the latest_timestamp" do
        post "/readings/create", params: readings
        get "/readings/latest_timestamp", params: { id: "36d5658a-6908-479e-887e-a949ec199272" }

        latest_timestamp = JSON.parse(response.body)["latest_timestamp"]

        expect(latest_timestamp).to eq("2021-09-29T16:09:15+01:00")
      end
    end

    context "when device readings do not exist" do
      it "returns the status not found" do
        get "/readings/latest_timestamp", params: { id: "36d5658a-6908-479e-887e-a949ec199272" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "GET /cumulative_count" do
    context "when device readings exist" do
      it "gets the cumulative_count" do
        post "/readings/create", params: readings
        get "/readings/cumulative_count", params: { id: "36d5658a-6908-479e-887e-a949ec199272" }

        cumulative_count = JSON.parse(response.body)["cumulative_count"]

        expect(cumulative_count).to eq(17)
      end
    end

    context "when device readings do not exist" do
      it "returns the status not found" do
        get "/readings/cumulative_count", params: { id: "36d5658a-6908-479e-887e-a949ec199272" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
