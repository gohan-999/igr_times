class IgrtimesController < ApplicationController

    require_dependency 'scrape'
    include Scrape

    AOYAMA_STATION = 0
    TAKIZAWA_STATION = 1

    def index
        @nobori_times = Scrape.station_train_times(AOYAMA_STATION, "NOBORI")
        @kudari_times = Scrape.station_train_times(AOYAMA_STATION, "KUDARI")
    end

end
