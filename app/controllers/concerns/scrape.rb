# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

module Scrape

    NOBORI_TIMES_TARGET_TAG = "//div[@class='post']/p[5]"
    KUDARI_TIMES_TARGET_TAG = "//div[@class='post']/p[4]"
    # 0 => 青山駅, 1 => 滝沢駅
    @station_times_url = ['http://www.igr.jp/wp/timetable/aoyama', 'http://www.igr.jp/wp/timetable/takizawa']

    def station_train_times(station_flg, cource_flg)
        if cource_flg == "NOBORI"
            return train_times_scrape(station_flg, NOBORI_TIMES_TARGET_TAG)
        else
            return train_times_scrape(station_flg, KUDARI_TIMES_TARGET_TAG)
        end
    end

    def train_times_scrape(station_flg, scrape_target_tag)

        # スクレイピング先のURL
        #url = 'http://www.igr.jp/wp/timetable/aoyama'

        charset = nil
        html = open(@station_times_url[station_flg]) do |f|
            charset = f.charset # 文字種別を取得
            f.read # htmlを読み込んで変数htmlに渡す
        end

        # htmlをパース(解析)してオブジェクトを生成
        docs = Nokogiri::HTML.parse(html, nil, charset)

        #対象ページの時刻表欄抽出
        lines = docs.xpath(scrape_target_tag).text
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
            #return next_trains
    end

    def next_hour_is_next_train?(now_time, time_str)
        if now_time.hour < time_str[0].to_i || now_time.min <= time_str[1].to_i
            true
        else
            false
        end
    end

end
