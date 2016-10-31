require "rufus-scheduler"
require 'capybara/poltergeist'
require "#{Rails.root}/config/initializers/scraper_utils.rb"
scheduler = Rufus::Scheduler.singleton
Capybara.javascript_driver = :poltergeist

def prepare_session()
  options = { js_errors: false, timeout: 1800, phantomjs_logger: StringIO.new, logger: nil, phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes', '--ssl-protocol=any'] }
  session = Capybara::Session.new(:poltergeist, options)
  session.driver.browser.url_blacklist = ["https://maxcdn.bootstrapcdn.com/", "https://www.tenders.vic.gov.au/tenders/res/"]
  session.driver.browser.js_errors = false
  session.driver.timeout = 1800
  session
end

def scrape_department_ids(department_list_url)
  session = prepare_session()
  session.visit department_list_url
  department_indexes_to_scrape = []
  department_links = session.find_all("a#MSG2")
  department_links.each do |department_link|
    department_id = find_between(department_link[:href], "issuingBusinessId=", "&")
    @saved_date = department_link[:href][-10..-1]
    department_indexes_to_scrape.push(department_id)
    puts "Department (#{department_id}) - #{department_link[:text]}"
      # break if department_link.text.include?("Department of Education and Training") # Stop after third dep DEBUG
  end
  session.driver.quit
  department_indexes_to_scrape
end

def scrape_contract_ids(department_indexes_to_scrape)
  contract_indexes = []
  department_indexes_to_scrape.each do |department_index|
    print "DEPARTMENT_#{department_index}: "
    page_number = 1
    previous_page = ""
    current_page = "not blank"
    while previous_page != current_page
      previous_page = current_page
      department_session = prepare_session()
      department_url = "https://www.tenders.vic.gov.au/tenders/contract/list.do?showSearch=false&action=contract-search-submit&issuingBusinessId=#{department_index}&issuingBusinessIdForSort=#{department_index}&pageNum=#{page_number}&awardDateFromString=#{@saved_date}"
      department_session.visit department_url
      contract_links = department_session.find_all("a#MSG2")
      print "<PAGE_#{page_number}> "
      contract_links.each do |contract_link|
        vt_reference = contract_link["href"].to_s[59..63]
        print "[#{vt_reference}] "
        contract_indexes.push vt_reference
          # break # stop after first contract DEBUG
      end
      current_page = department_session.text
      department_session.driver.quit
      page_number += 1
    end
    print "\n"
  end
  contract_indexes
end

def scrape_for_references(department_list_url)
  department_indexes_to_scrape = scrape_department_ids(department_list_url)
  puts "DEPS TO SCRAPE: #{department_indexes_to_scrape}"
  contract_indexes = scrape_contract_ids(department_indexes_to_scrape)
  puts "CONTRACTS TO SCRAPE: #{contract_indexes}"
  contract_indexes
end

  scrape_now = scheduler.every '1h', :first_at => Time.now + 7 do #  '1h', :first_at => Time.now() + 5 do
# scrape_in_10 = scheduler.every '1h', :first_at => Time.now + 600 do #  '1h', :first_at => Time.now() + 5 do
# hourly_scrape = scheduler.every '1h', :first_at => Time.parse("4:00:00 pm") do #  '1h', :first_at => Time.now() + 5 do
# daily_scrape = scheduler.every '1d', :first_at => Time.parse("11:55:00 pm") do #  '1h', :first_at => Time.now() + 5 do
  Rails.logger.info "Log || SCRAPE || At: #{Time.now}"
  contract_indexes_to_scrape = scrape_for_references("https://www.tenders.vic.gov.au/tenders/contract/list.do?action=contract-view")
  contract_session = prepare_session()
  Capybara.reset_sessions!
  contract_indexes_to_scrape.to_set.each do |contract_index|
    contract_session.visit "http://www.tenders.vic.gov.au/tenders/contract/view.do?id=#{contract_index}"
    contract_data = extract_contract_data(contract_session.text, contract_index)
    store_or_skip(contract_data)
  end
  contract_session.driver.quit
  Rails.logger.info " :: Completed Scraping ::"
end
