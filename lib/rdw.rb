require "rdw/version"
require "net/http"
require "nokogiri"

module RDW

  class CarInfo

    def initialize(license_plate)
      @license_plate = license_plate
      perform_request!
    end

    def number_of_cylinders
      parse("Aantalcilinders").to_i
    end

    def number_of_seats
      parse("Aantalzitplaatsen").to_i
    end

    def BPM
      parse("BPM").to_i
    end

    def fuel_efficiency_main_road
      parse("Brandstofverbruikbuitenweg").to_f
    end

    def fuel_efficiency_city
      parse("Brandstofverbruikstad").to_f
    end

    def fuel_efficiency_combined
      parse("Brandstofverbruikgecombineerd").to_f
    end

    def cylinder_capacity
      parse("Cilinderinhoud").to_f
    end

    def co2_combined
      parse("CO2uitstootgecombineerd").to_f
    end

    def color
      parse("Eerstekleur")
    end

    def fuel_type
      parse("Hoofdbrandstof")
    end

    def brand
      parse("Merk")
    end

    def trade_name
      parse("Handelsbenaming")
    end

    def energy_label
      parse("Zuinigheidslabel")
    end

    def stock_price
      parse('Catalogusprijs')
    end

    def engine_power
      parse('Vermogen')
    end

    def inspect
      "<RDW::CarInfo license_plate:'#{@license_plate}' brand:'#{brand}' fuel_type:'#{fuel_type}'>"
    end

    def raw_data_field(attribute_name)
      parse(attribute_name)
    end

  private

    def parse(attribute_name)
      begin
        @xml.xpath("//d:#{attribute_name.to_s}").text
      rescue
        nil
      end

    end

    def perform_request!
      response = Net::HTTP.get_response(URI("https://api.datamarket.azure.com/Data.ashx/opendata.rdw/VRTG.Open.Data/v1/KENT_VRTG_O_DAT('#{@license_plate}')"))
      @xml = Nokogiri::XML(response.body)
    end
  end
end
