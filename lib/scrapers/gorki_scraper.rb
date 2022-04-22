# frozen_string_literal: true

class Scrapers::GorkiScraper < Scrapers::Scraper
  ROOT_URL = "https://www.gorki.de"
  URL = 'https://www.gorki.de/en/programme/2022/04/all'
  GORKI_ENUM = 1

  def self.handle
    begin
      total_events = []
      parsed_page = get_parsed_page(URL)
      return [total_events, 'failed', "couldn't conect to #{URL}"] if parsed_page.blank?

      available_urls_to_parse = get_urls(parsed_page)
      available_urls_to_parse.each do |url|
        parsed_page = get_parsed_page(url)
        month_from_url = url.split('/')[-2]
        total_events += parse_each_url(parsed_page, month_from_url)
      end
      [total_events, 'success', ''] # events, status, errors
    rescue StandardError => e
      Rails.logger.error "GorkiScraper#handle: Failed to scrape due to #{e.message} #{e.backtrace}"
      [total_events, 'failed', e.message] # events, status, errors 
    end
  end

  def self.parse_each_url(parsed_page, month_from_url)
    events = []
    card_number = 1
    while(!parsed_page.xpath("//*[@id='block-gorki-content']/div[1]/div[#{card_number}]").empty?)
      inner_div = 1
      date = parsed_page.xpath("//*[@id='block-gorki-content']/div[1]/div[#{card_number}]/div/div[#{inner_div}]/div/h2").text
      inner_div += 1
      while(!parsed_page.xpath("//*[@id='block-gorki-content']/div[1]/div[#{card_number}]/div/div[#{inner_div}]").empty?)
        title = parsed_page.xpath("//*[@id='block-gorki-content']/div[1]/div[#{card_number}]/div/div[#{inner_div}]/div/div/div[1]/div/div[1]/div/div[2]/h2/a").text
        description = parsed_page.xpath("//*[@id='block-gorki-content']/div[1]/div[#{card_number}]/div/div[#{inner_div}]/div/div/div[1]/div/div[2]/article/div[2]/div/div/p").text
        events << {
          start_date: get_date(date, month_from_url),
          end_date: get_date(date, month_from_url),
          title: title,
          description: description,
          web_source: GORKI_ENUM
        }
        inner_div += 1
      end 
      card_number += 1
    end
    events
  end

  def self.get_date(date, month)
    Date.strptime("#{date}/#{month}/2022", '%d/%m/%Y')
  end

  def self.get_urls(parsed_page)
    months_list = 1
    available_urls_to_parse = []
    uri_end_point = parsed_page.xpath("//*[@id='block-gorki-content']/section/div/div/div[2]/ul/li[#{months_list}]/a/@href")
    while(!uri_end_point.empty?)
      available_urls_to_parse << ROOT_URL + uri_end_point.text
      months_list += 1
      uri_end_point = parsed_page.xpath("//*[@id='block-gorki-content']/section/div/div/div[2]/ul/li[#{months_list}]/a/@href")
    end
    available_urls_to_parse
  end
end
