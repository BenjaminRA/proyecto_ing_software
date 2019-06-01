class ApplicationController < ActionController::Base

    def index
        @title = "Dashboard"
        @categories = Category.all
        @areas = Area.all

        gon.categories = @categories
        gon.areas = @areas
    end

end
