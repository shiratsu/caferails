# coding: utf-8
require 'open-uri'
require 'json'
require "date"

class Tasks::GeoCooding

  #変数初期化
  @@start       = 0;
  @@apikey      = 'a3050b53541d7189c7d6da8ba3303d91'
  @@limit       = 200
  @@loop_limit  = 50
  @@loop_count  = 0
  @@api_url = 'http://maps.googleapis.com/maps/api/geocode/json?'


  # メイン処理
  def self.execute

    point = 0
    # puts 'test'
    #まずは、DBから値を取得
    geocode_results = GeocodeResults.find_by(:id => '1')
    # puts 'test'
    #終了ポイントがあれば取り出す
    unless geocode_results.blank?
      point = geocode_results.point
    end

    #カフェデータの住所も取得
    cafe_list = Cafe.find(:all, :offset => 5000, :limit => point)

    Cafe.find(:all, :offset => 5000, :limit => point).each { |cafe|
      self.main(cafe.address,cafe.id)
    }

    year  = Time.now.year
    month = Time.now.month
    day   = Time.now.day
    date = sprintf("%04d-%02d-%02d",year,month,day)
    puts date
    ##ループ結果を保存して終了
    ##TODO:elseはまだ途中
    if geocode_results != nil

      geocode_results.id = 1
      geocode_results.point = point+5000
      geocode_results.date = date
      geocode_results.save
    else
      puts date
      geocode_results = GeocodeResults.create(
        :id => 1,
        :point => point+5000,
        :date => date
      )

    end


  end

  def self.main(address,cafe_id)
    #address2 = address.split(/\s+/)[0]+' '+address.split(/\s+/)[1];

    freeword = URI.encode(address)
puts @@api_url+'address='+freeword+'&sensor=true'
    uri = URI.parse(@@api_url+'address='+freeword+'&sensor=true')
    json = Net::HTTP.get(uri)
    result = JSON.parse(json)
puts cafe_id
puts result['results']
puts result['results'][0]
    unless result['results'].blank?
      lat = result['results'][0]['geometry']['location']['lat']
      lng = result['results'][0]['geometry']['location']['lng']

      cafe = Cafe.find_by(:id => cafe_id)
      cafe.lat = lat.to_s
      cafe.lng = lng.to_s
      cafe.save

    end

    # Cafe.import cafe_list

  end

end