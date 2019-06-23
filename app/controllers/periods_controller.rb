class PeriodsController < ApplicationController
    before_action :is_admin

    
    def index
        @title = "Periodos"


    end

    def show



    end

    def new
        @title = "Crear Periodo"

        @collaborators = Collaborator.all.joins(:user)

        gon.collaborators = @collaborators.map {|collaborator| {
            :id => collaborator.id,
            :rut => collaborator.user.rut,
            :name => collaborator.user.name,
            :last_name => collaborator.user.last_name,
        }}
    end

    def create
        # puts params[:start]
        # puts params[:end]

        params[:collaborators].each do |collaborator_id|
            # puts collaborator_id
        end

        params[:evaluators].each do |collaborator_id|
            # puts collaborator_id
        end

        params[:evaluates].each do |aux|
            puts "#{aux[0]} -> #{aux[1]}"
        end

    end

    def edit



    end

end
