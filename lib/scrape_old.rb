# 予備用のファイル（concernsから読み込むので）
#
# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

module Scrape

    TIMES_TARGET_TAG = "//div[@class='post']/p[4]"

    def station_times_scrape
        # スクレイピング先のURL
        url = 'http://www.igr.jp/wp/timetable/aoyama'

        charset = nil
        html = open(url) do |f|
            charset = f.charset # 文字種別を取得
            f.read # htmlを読み込んで変数htmlに渡す
        end

        # htmlをパース(解析)してオブジェクトを生成
        docs = Nokogiri::HTML.parse(html, nil, charset)

        #対象ページの時刻表欄抽出
        lines = docs.xpath(TIMES_TARGET_TAG).text
        times = lines.to_s.strip.split(/[\r\n]+/)

        time_and_sts = times.map do |time|
            time.split(/[\s]/) if time =~ /^[0-9]+:[0-9]+/
        end.compact

            now_time = Time.now

            next_trains = time_and_sts.map do |time|
                time_str = time[0].split(/[:]/)
                if now_time.hour <= time_str[0].to_i
                    time if next_hour_is_next_train?(now_time, time_str)
                end
            end.compact
            return next_trains
    end

    def next_hour_is_next_train?(now_time, time_str)
        if now_time.hour < time_str[0].to_i || now_time.min <= time_str[1].to_i
            true
        else
            false
        end
    end

end
