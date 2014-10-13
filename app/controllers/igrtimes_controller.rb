require 'scrape'
include Scrape
class IgrtimesController < ApplicationController

    def index
        @times = Scrape.aoyama_kudari
    end

end
