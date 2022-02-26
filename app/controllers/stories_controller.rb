class StoriesController < ApplicationController
    def index
      @stories = Story.all
        puts "ESTOU AQUI"
    end
  end