# frozen_string_literal: true

class Event < ApplicationRecord
  enum web_source: %i[co_berlin gorki]

  #validations
  validates :title, :event_date, :web_source, presence: true
  validates :title, uniqueness: { scope: [:start_date, :end_date, :web_source] }

  #scopes
  scope :search_title, ->(text) { where('events.title LIKE ?', "%#{text}%") }
  scope :web_source, ->(source) { where(web_source: source) }
  scope :on_date, ->(date) { where('events.start_date <= ? AND events.end_date >= ?', date, date) }
  scope :start_date_between, ->(start_date, end_date) { where('events.start_date BETWEEN ? AND ?', start_date, end_date) }

  class << self
    def scrape_and_create_co_berlin_events
      co_berlin_events, status, errors = Scrapers::CoBerlinScraper.handle
      if(status == 'success')
        Event.insert_all(co_berlin_events) if co_berlin_events.present?
        [status, errors]
      else
        [status, errors]
      end
    end

    def scrape_and_create_gorki_events
      gorki_events, status, errors = Scrapers::GorkiScraper.handle
      if(status == 'success')
        Event.insert_all(gorki_events) if gorki_events.present?
        [status, errors]
      else
        [status, errors]
      end
    end
  end
end
