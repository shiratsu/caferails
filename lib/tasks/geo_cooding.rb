# coding: utf-8
require 'open-uri'
require 'json'
require "date"

class Tasks::GeoCooding

  #変数初期化
  @@start       = 0;
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
    Cafe.find(:all, :conditions => {:latlng_update_flag => nil},:offset => point, :limit => 2400 ).each { |cafe|

      #住所をもとに緯度経度を取り出す
      self.main(cafe.address,cafe.id)
    }

    #住所をもとに緯度経度を取り出す
    # self.main("〒100-0006 東京都千代田区有楽町2-5-1 ルミネ有楽町 ルミネ1 3F","gazv401")Time.now.month
    year  = Time.now.year
    month = Time.now.month
    day   = Time.now.day
    date = sprintf("%04d-%02d-%02d",year,month,day)
    puts date
    ##ループ結果を保存して終了

    if geocode_results != nil

      geocode_results.id = 1
      geocode_results.point = point+2400
      geocode_results.date = date
      geocode_results.save
    else
      puts date
      geocode_results = GeocodeResults.create(
        :id => 1,
        :point => point+2400,
        :date => date
      )

    end


  end

  #住所をもとに緯度経度を取り出して、DBに保存
  def self.main(address,cafe_id)
    #address2 = address.split(/\s+/)[0]+' '+address.split(/\s+/)[1];

    freeword = URI.encode(address)
# puts @@api_url+'address='+freeword+'&sensor=true'
    uri = URI.parse(@@api_url+'address='+freeword+'&sensor=true')
    json = Net::HTTP.get(uri)
    result = JSON.parse(json)
#puts cafe_id
# puts result['results']
# puts result['results'][0]
    unless result['results'].blank?
      lat = result['results'][0]['geometry']['location']['lat']
      lng = result['results'][0]['geometry']['location']['lng']

      cafe = Cafe.find_by(:id => cafe_id)
      cafe.lat = lat.to_s
      cafe.lng = lng.to_s
      cafe.latlng_update_flag = 1
      cafe.save
    else
      if address.split(/\s+/).length >= 3
        address = address.split(/\s+/)[0]+' '+address.split(/\s+/)[1];
        self.main(address,cafe_id)
      end
    end

    # Cafe.import cafe_list

  end

end