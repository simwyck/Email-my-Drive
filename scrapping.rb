# On fait appelle au fichier de vendredi dernier
#require_relative "/home/simwyck/Bureau/THP/J11/route_mairie.rb"
#require_relative "/home/simwyck/Bureau/THP/J11/ggspreadsheet.rb"
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'pry'
require 'csv'

def get_the_email_of_a_townhal_from_its_webpage(url_page)
  #binding.pry
  page = Nokogiri::HTML(open(url_page))
  mail = page.css("td.style27 p.Style22 font")[6]
  mail.text
end

def get_all_the_urls_of_department_townhalls()
  department_urls = ["http://annuaire-des-mairies.com/gironde.html","http://annuaire-des-mairies.com/gironde-2.html","http://annuaire-des-mairies.com/gironde-3.html"]
  res = []
  department_urls.each do |department_url|
    page_annuaire = Nokogiri::HTML(open(department_url))
    pages_mairies = page_annuaire.css("table p a.lientxt")
    pages_mairies.each{|mairie|  mairie["href"]= right_url(mairie["href"])}
    pages_mairies
    res = res + pages_mairies
  end
  res
end

def right_url(url)
  url ='http://annuaire-des-mairies.com' + url.split('').drop(1)*''
end

def perform()
    res = []
    get_all_the_urls_of_department_townhalls().each do |mairie_url|
      nom = mairie_url.text
      email = get_the_email_of_a_townhal_from_its_webpage(mairie_url["href"])
      res << {:name =>nom , :email=>email }
      p nom + " " + email
    end
    res
end

puts perform()

# On crée un fichier CSV avec les valeurs
def createcsv
  CSV.open("mairies_gironde.csv", "wb") do |csv|
    perform().each do |h|
      csv << h.values
    end
  end
end

createcsv
