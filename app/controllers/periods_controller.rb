class PeriodsController < ApplicationController
    before_action :is_admin

    
    def index
        @title = "Periodos"
        @periods = Period.all

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
        aux_start = params[:start].split("/")
        aux_end = params[:end].split("/")
        period = Period.create({
            :start_date => "#{aux_start[2]}-#{aux_start[0]}-#{aux_start[1]}",
            finish_date: "#{aux_end[2]}-#{aux_end[0]}-#{aux_end[1]}",
        })

        params[:collaborators].each do |collaborator_id|
            evaluator = Evaluator.create({
                :collaborator_id => collaborator_id,
                :period_id => period.id
            })
            Evaluation.create({
                :collaborator_id => collaborator_id,
                :evaluator_id => evaluator.id
            })
        end

        params[:evaluates].each do |aux|
            evaluator = Evaluator.where(:period_id => period.id, :collaborator_id => aux[0]).first
            aux[1].each do |collaborator_id|
                Evaluation.create({
                    :collaborator_id => collaborator_id,
                    :evaluator_id => evaluator.id
                })
            end
        end

        redirect_to "/periods"

    end

    def edit



    end

end
