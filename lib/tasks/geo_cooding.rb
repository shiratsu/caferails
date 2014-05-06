# coding: utf-8
require 'open-uri'
require 'rexml/document'
require 'uri'
require "date"

class Tasks::CafeCrawl

  #変数初期化
  @@start       = 0;
  @@apikey      = 'a3050b53541d7189c7d6da8ba3303d91'
  @@limit       = 200
  @@loop_limit  = 50
  @@loop_count  = 0
  @@api_url = 'http://api.gnavi.co.jp/ver1/RestSearchAPI/?'


  # メイン処理
  def self.execute

    start = 0
    # puts 'test'
    #まずは、DBから値を取得
    crawl_result = CrawlResults.find_by(:crawl_id => '1')
    # puts 'test'
    #終了ポイントがあれば取り出す
    unless crawl_result.blank?
      start = crawl_result.start
    end

    loopstart = 0
    for num in 0..@@loop_limit do
      loopstart = start + @@limit*num
      # puts loopstart.to_s
      self.main(loopstart)
    end

    #最後の後始末
    start = loopstart

    year  = Time.now.year
    month = Time.now.month
    day   = Time.now.day
    date = sprintf("%04d-%02d-%02d",year,month,day)
    puts date
    ##ループ結果を保存して終了
    ##TODO:elseはまだ途中
    if crawl_result != nil

      crawl_result.crawl_id = 1
      crawl_result.start = start
      crawl_result.crawl_date = date
      crawl_result.save
    else
      puts date
      crawl_result = CrawlResults.create(
        :crawl_id => 1,
        :start => start,
        :crawl_date => date
      )
      puts crawl_result.start
    end


  end

  def self.main(start)
    freeword = URI.encode('カフェ')
    doc = REXML::Document.new(open(@@api_url+'keyid='+@@apikey+'&offset='+start.to_s+'&hit_per_page='+@@limit.to_s+'&freeword='+freeword))

    puts @@api_url+'keyid='+@@apikey+'&offset='+start.to_s+'&hit_per_page='+@@limit.to_s+'&freeword='+freeword
    return_count = doc.elements['response/total_hit_count'].text

    #ループでバルクインサート作る
    cafe_list = []
    crawl_list = []

    doc.elements.each('response/rest') do |element|
      if element.elements['id'] != nil
        # puts element.elements['name'].text
        # puts product[1]['Name']
        # puts product[1]['Description']
        # puts product[1]['Url']
        # puts product[1]['Image']['Small']
        # puts product[1]['Image']['Medium']
        # puts product[1]['ProductId']
        # puts product[1]['PriceLabel']['FixedPrice']
        # puts product[1]['PriceLabel']['DefaultPrice']
        # puts product[1]['PriceLabel']['SalePrice']
        # puts product[1]['PriceLabel']['PeriodStart']
        # puts product[1]['PriceLabel']['PeriodEnd']
        # puts '======================================'

        puts element
        puts element.elements['id'].text
        puts element.elements['name'].text
        puts element.elements['latitude'].text
        puts element.elements['longitude'].text
        puts element.elements['url'].text
        puts element.elements['address'].text

        # cafe_list << Cafe.new(
        # id:element.elements['id'].text,
        # store_name: element.elements['name'].text,
        # lat: element.elements['latitude'].text,
        # lng: element.elements['longitude'].text,
        # url: element.elements['url'].text,
        # address: element.elements['address'].text
        # )

      end
    end
    # Cafe.import cafe_list

  end

end