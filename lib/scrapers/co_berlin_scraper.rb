# frozen_string_literal: true

class Scrapers::CoBerlinScraper < Scrapers::Scraper
  URL = 'https://co-berlin.org/en/program/calendar'
  CO_BERLIN_ENUM = 0

  def self.handle
    begin
      total_events = []
      parsed_page = get_parsed_page(URL)
      return [total_events, 'failed', "couldn't conect to #{URL}"] if parsed_page.blank?

      total_events += get_parsed_events(parsed_page)
      [total_events, 'success', ''] # events, status, errors
    rescue StandardError => e
      Rails.logger.error "CoBerlinScraper#handle: Failed to scrape due to #{e.message} #{e.backtrace}"
      [total_events, 'failed', e.message] # events, status, errors 
    end
  end

  def self.get_parsed_events(parsed_page)
    root_xpath = "//*[@id='block-cob-content']/article/div/div[2]/div/div/div/div/div/div/div[3]/div/div/div/div/div[2]"
    card_changer = 1
    card_element = parsed_page.xpath("#{root_xpath}/div[#{card_changer}]")
    events = []
    while(!card_element.empty?)
      dates = parsed_page.xpath("#{root_xpath}/div[#{card_changer}]/article/a/div/div/div[2]/div[1]/div/span").text
      title = parsed_page.xpath("#{root_xpath}/div[#{card_changer}]/article/a/div/div/div[2]/div[2]/span/h2").text
      description = parsed_page.xpath("#{root_xpath}/div[#{card_changer}]/article/a/div/div/div[2]/div[3]/div").text
      dates = get_all_dates(dates)
      events << {
        start_date: dates[0],
        end_date: dates[1].present? ? dates[1] : dates[0],
        title: title,
        description: description,
        web_source: CO_BERLIN_ENUM
      }
      card_changer += 1
      card_element = parsed_page.xpath("#{root_xpath}/div[#{card_changer}]")
    end
    events
  end

  def self.get_all_dates(date)
    dates = date.split('–')
    dates.map do |date|
      Date.parse(date)
    end
  end
end
