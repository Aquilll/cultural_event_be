# frozen_string_literal: true

class EventsController < ApplicationController
  
  # GET /events
  def index
    @events = Event.all.order(created_at: :desc)
    if @events.present?
      return render json: payload(@events.to_a), status: :ok
    else
      return render json: [], status: :ok
    end
  end

  # POST /events/create_gorki_events
  def create_gorki_events
    status, errors = Event.scrape_and_create_gorki_events
    if(status == 'success')
      return render json: { data: 'gorki event successfully created', status: status }, status: :created
    else
      return render json: { status: status, errors: errors }, status: :unprocessable_entity
    end
  end

  # POST /events/create_co_berlin_events
  def create_co_berlin_events
    status, errors = Event.scrape_and_create_co_berlin_events
    if(status == 'success')
      return render json: { data: 'co_berlin event successfully created', status: status }, status: :created
    else
      return render json: { status: status, errors: errors }, status: :unprocessable_entity
    end
  end
end