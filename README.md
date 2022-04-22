# README

### DEPENDENCIES
* Required ruby version: 2.7.4

### Setup
* clone the repo
* cd /cultural_event_be
* bundle install
* rails db:migrate
* rails s

### API ENDPOINTS
* GET /events
  lists all events

* POST /create_gorki_events
   - creates events from gorki

* POST /create_co_berlin_events
   - creates events from co_berlin

* GET /search
  - params:
    - text: any text to be searched up on
    - date: filter for a particular date
    - start_date: filter for a data range
    - end_date: filter for a date range
    - web_source: enum 0 for events from co_berlin and 1 for events from gorki
   - NOTE: when sending `start_date` and `end_date` as parameter, don't send `date` parameter and similarly when sending `start_date` and `end_date`, don't send the `date` parameter


###NOTE: 
Initially all the events will be empty, we can start by sending a post request to /create_gorki_events or /create_co_berlin_events
