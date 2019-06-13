class PeriodsController < ApplicationController
    before_action :is_admin

    
    def index
        @title = "Periodos"


    end

    def show



    end

    def new
        @title = "Crear Periodo"

        @collaborators = Collaborator.all

        gon.collaborators = @collaborators
    end

    def create
        puts params


    end

    def edit



    end

end
