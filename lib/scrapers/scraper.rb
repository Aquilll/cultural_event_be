class Scrapers::Scraper
  RETRIES_LIMIT = 3
  
  def self.get_parsed_page(url)
    retries = 0
    parsed_page = nil
    begin
      parsed_page = Nokogiri::HTML(HTTParty.get(url))
    rescue Net::ReadTimeout
      retries += 1
      rails.logger.info("Scraper#get_parsed_page: time out while connecting to #{ulr} retrying: #{retries}/#{RETRIES_LIMIT}")
      retry if retries <= RETRIES_LIMIT
    end
    parsed_page
  end
end