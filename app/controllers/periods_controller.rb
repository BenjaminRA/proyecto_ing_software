class PeriodsController < ApplicationController
    before_action :is_admin

    
    def index
        @title = "Periodos"
        @periods = Period.all
    end

    def show
        @title = "Período"

        @collaborators = Evaluation.joins(evaluator: {collaborator: :user})
            .where("evaluations.collaborator_id = evaluators.collaborator_id")
            .where(["evaluators.period_id = ?", params[:id]]).uniq
        @evaluators = Evaluation.joins(evaluator: {collaborator: :user})
            .where("evaluations.collaborator_id != evaluators.collaborator_id")
            .where(["evaluators.period_id = ?", params[:id]])

        @to_evaluate = []

        @evaluators.each do |evaluator|
            aux = Evaluation.joins(collaborator: :user, evaluator: {collaborator: :user})
                    .where("evaluations.collaborator_id != evaluators.collaborator_id")
                    .where(["evaluators.collaborator_id = ?", evaluator.collaborator.id])
                    .where(["evaluators.period_id = ?", params[:id]])
            @to_evaluate << aux
        end

        # render :plain => @evaluators.inspect

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
        end if (params[:collaborators].present?)

        params[:evaluates].each do |aux|
            evaluator = Evaluator.where(:period_id => period.id, :collaborator_id => aux[0]).first
            aux[1].each do |collaborator_id|
                Evaluation.create({
                    :collaborator_id => collaborator_id,
                    :evaluator_id => evaluator.id
                })
            end
        end if (params[:evaluates].present?)

        redirect_to "/periods"

    end

    def edit

    end

    def report
        @title = "Reporte"

        @collaborator = Collaborator.where(:id => params[:collaborator]).joins(:user, profile: {profile_abilities: :ability}).first
        @autoevaluation = Evaluation.joins(evaluator: {collaborator: :user})
            .where("evaluations.collaborator_id = evaluators.collaborator_id")
            .where("evaluations.collaborator_id = #{params[:collaborator]}")
            .where(["evaluators.period_id = ?", params[:period]])
            .joins(evaluation_abilities: :ability).first

        @evaluation = Evaluation.joins(evaluator: {collaborator: :user})
            .where("evaluations.collaborator_id != evaluators.collaborator_id")
            .where("evaluations.collaborator_id = #{params[:collaborator]}")
            .where(["evaluators.period_id = ?", params[:period]])
            .joins(evaluation_abilities: :ability).first

        gon.collaborator = {
            :required => @collaborator.profile.profile_abilities.map {|entry| {
                :ability_type => entry.ability.abilities_type_id,
                :ability => entry.ability.ability,
                :value => entry.value
            }},
            :autoevaluation => !@autoevaluation.nil? ? @autoevaluation.evaluation_abilities.map {|entry| {
                :ability_type => entry.ability.abilities_type_id,
                :ability => entry.ability.ability,
                :value => entry.value
            }} : nil,
            :evaluation => !@evaluation.nil? ? @evaluation.evaluation_abilities.map {|entry| {
                :ability_type => entry.ability.abilities_type_id,
                :ability => entry.ability.ability,
                :value => entry.value
            }} : nil,
        }

    end
end
