# README

## TODOS
- Create a service layer to clean up business logic in controller
  - Ideally would use the interactor gem for this
- Implement error handling for unexpected JSON payloads
  - A lot of this logic would go into the interactors (service layer)
- Add pagination for fetching readings if dealing with large datasets
- Use Redis for caching

## Installation
- Clone this repository to your local machine:
  - `git clone https://github.com/yourusername/device_readings_api.git`
- Navigate to the project directory:
  - `cd device_readings_api`
- Install dependencies using bundler:
  - `bundle install`

### Usage
- Start the rails server:
  - `rails server`

The API will now be accessible locally at http://localhost:3000.

### Testing
You can test the API endpoints using tools like curl, Postman, or by sending HTTP requests from your frontend or another application.


# Device Readings API Documentation
## Base URL
```
http://localhost:3000
```

## Endpoints
### URL: `/readings/create`
### Method: POST
### Description: Stores readings for devices
### Parameters:
- `id` (string, required): A string representing the UUID for the device.
- `readings` (array of objects, required): An array of readings for the device.
- `timestamp` (string, required): An ISO-8061 timestamp for when the reading was taken.
- `count` (integer, required): An integer representing the reading data.
### Request payload example:
```
{
  "id": "36d5658a-6908-479e-887e-a949ec199272",
  "readings": [
    {
      "timestamp": "2021-09-29T16:08:15+01:00",
      "count": 2
    },
    {
      "timestamp": "2021-09-29T16:09:15+01:00",
      "count": 15
    }
  ]
}
```
### Response:
- Status Code: 201 Created

### URL: `/readings/latest_timestamp`
### Method: GET
### Description: Retrieves the timestamp of the latest reading for a specific device.
### Parameters:
- `id` (string, required): A string representing the UUID for the device.
### Request example:
```
http://localhost:3000/readings/latest_timestamp?id=36d5658a-6908-479e-887e-a949ec199272
```
### Response example:
```
{
  "latest_timestamp": "2021-09-29T16:09:15+01:00"
}
```
- Status Code: 200 OK

### URL: `/readings/cumulative_count`
### Method: GET
### Description: Retrieves the cumulative count across all readings for a specific device.
### Parameters:
- `id` (string, required): A string representing the UUID for the device.

### Request example:
```
http://localhost:3000/readings/cumulative_count?id=36d5658a-6908-479e-887e-a949ec199272
```
### Response example:
```
{
  "cumulative_count": 17
}
```
- Status Code: 200 OK
