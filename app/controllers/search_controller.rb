# frozen_string_literal: true

class SearchController < ApplicationController

  # GET /search
  def index
    @events = Event.all
    if(permitted_params[:text].present?)
      @events = @events.search_title(permitted_params[:text])
    end
    if(permitted_params[:start_date].present? && permitted_params[:end_date].present?)
      @events = @events.start_date_between(Date.strptime(permitted_params[:start_date], '%d/%m/%Y'), Date.strptime(permitted_params[:end_date], '%d/%m/%Y'))
    end
    if(permitted_params[:date].present?)
      @events = @events.on_date(Date.strptime(permitted_params[:date], '%d/%m/%Y'))
    end
    if(permitted_params[:web_source].present?)
      @events = @events.web_source(permitted_params[:web_source])
    end
    if @events.present?
      return render json: payload(@events.to_a), status: :ok
    else
      return render json: [], status: :ok
    end
  end

  def permitted_params
    params.permit(:text, :date, :start_date, :end_date, :web_source)
  end
end