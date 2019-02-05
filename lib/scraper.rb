require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = Nokogiri::HTML(open(index_url))
    html.css('.student-card').collect {|student|
      {
      name: student.css('.student-name').text,
      location: student.css('.student-location').text,
      profile_url: student.css('a').attribute('href').value
      }
    }
  end

  def self.scrape_profile_page(profile_url)
    html = Nokogiri::HTML(open(profile_url))
    student = {}

    html.css('.social-icon-container a').each {|link|
      if link.attribute('href').value.include?('twitter')
        student[:twitter] = link.attribute('href').value
      elsif link.attribute('href').value.include?('linkedin')
        student[:linkedin] = link.attribute('href').value
      elsif link.attribute('href').value.include?('github')
        student[:github] = link.attribute('href').value
      else
        student[:blog] = link.attribute('href').value
      end
    }

    student[:profile_quote] = html.css('.profile-quote').text
    student[:bio] = html.css('.bio-content .description-holder').text.strip
    student
  end
end
