class PeriodsController < ApplicationController
    def index
        @title = "Periodos"

        @categories = Category.all
        @areas = Area.all

        gon.categories = @categories
        gon.areas = @areas
    end

    def show


        @categories = Category.all
        @areas = Area.all

        gon.categories = @categories
        gon.areas = @areas
    end

    def new
        @title = "Crear Periodo"

        @collaborators = Collaborator.all
        @categories = Category.all
        @areas = Area.all

        gon.categories = @categories
        gon.areas = @areas
        gon.collaborators = @collaborators
    end

    def create
        puts params

        @categories = Category.all
        @areas = Area.all

        gon.categories = @categories
        gon.areas = @areas
    end

    def edit


        @categories = Category.all
        @areas = Area.all

        gon.categories = @categories
        gon.areas = @areas
    end

end
