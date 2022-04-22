class ApplicationController < ActionController::API
  GORKI_URL = 'https://www.gorki.de/en/programme'
  CO_BERLIN_URL = 'https://co-berlin.org/en/program/calendar'

  def payload(events)
    datas = []
    if(events.is_a?(Array))
      events.each do |event|
        datas << get_event_hash(event)
      end
    end
    datas.present? ? datas : get_event_hash(events)
  end

  def get_event_hash(event)
    {
      id: event.id,
      event_start_date: event.start_date,
      event_end_date: event.end_date,
      title: event.title,
      description: event.description,
      web_source: event.web_source,
      web_url: event.web_source == 'gorki' ? GORKI_URL : CO_BERLIN_URL
    }
  end
end
