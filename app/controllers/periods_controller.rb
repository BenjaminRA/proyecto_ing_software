class PeriodsController < ApplicationController
    before_action :is_admin

    
    def index
        @title = "Periodos"
        @periods = Period.all

        @periods = @periods.where("start_date >= '#{params[:year]}-01-01 00:00:00' and finish_date < '#{params[:year].to_i + 1}-01-01 00:00:00'") if params[:year].present?
    end

    def show
        @title = "Período"

        @collaborators = Evaluation.joins(evaluator: {collaborator: :user})
            .where("evaluations.collaborator_id = evaluators.collaborator_id")
            .where(["evaluators.period_id = ?", params[:id]]).uniq
        @evaluators = Evaluation.joins(evaluator: {collaborator: :user})
            .where("evaluations.collaborator_id != evaluators.collaborator_id")
            .where(["evaluators.period_id = ?", params[:id]]).group("evaluators.collaborator_id")

        @to_evaluate = []

        @evaluators.each do |evaluator|
            aux = Evaluation.joins(collaborator: :user, evaluator: {collaborator: :user})
                    .where("evaluations.collaborator_id != evaluators.collaborator_id")
                    .where(["evaluators.collaborator_id = ?", evaluator.evaluator.collaborator.id])
                    .where(["evaluators.period_id = ?", params[:id]])
            @to_evaluate << aux
        end

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

        gon.periods = Period.all

        if (@collaborators.count == 0)
            flash[:mensaje] = "Debe crear al menos 1 Colaborador"
            redirect_to "/collaborators"
        end
    end

    def create
        aux_start = params[:start].split("-")
        aux_end = params[:end].split("-")

        period = Period.create({
            :start_date => "#{aux_start[2]}-#{aux_start[1]}-#{aux_start[0]}",
            finish_date: "#{aux_end[2]}-#{aux_end[1]}-#{aux_end[0]}",
        })

        params[:collaborators].each do |collaborator_id|
            evaluator = Evaluator.create({
                :collaborator_id => collaborator_id,
                :period_id => period.id
            })
            collaborator = Collaborator.find(collaborator_id)
            Evaluation.create({
                :collaborator_id => collaborator_id,
                :evaluator_id => evaluator.id,
                :profile_id => collaborator.profile.id
            })
        end if (params[:collaborators].present?)

        params[:evaluates].each do |aux|
            evaluator = Evaluator.where(:period_id => period.id, :collaborator_id => aux[0]).first
            aux[1].each do |collaborator_id|
                collaborator = Collaborator.find(collaborator_id)
                Evaluation.create({
                    :collaborator_id => collaborator_id,
                    :evaluator_id => evaluator.id,
                    :profile_id => collaborator.profile.id
                })
            end
        end if (params[:evaluates].present?)

        redirect_to "/periods/#{period.id}"

    end

    def edit
        @title = "Editar Periodo"

        @collaborators = Collaborator.all.joins(:user)

        period = Period.find(params[:id])
        
        @start = "#{period.start_date.month.to_i < 10 ? "0#{period.start_date.month}" : period.start_date.month}/#{period.start_date.day.to_i < 10 ? "0#{period.start_date.day}" : period.start_date.day}/#{period.start_date.year}"
        @end = "#{period.finish_date.month.to_i < 10 ? "0#{period.finish_date.month}" : period.finish_date.month}/#{period.finish_date.day.to_i < 10 ? "0#{period.finish_date.day}" : period.finish_date.day}/#{period.finish_date.year}"

        gon.collaborators = @collaborators.map {|collaborator| {
            :id => collaborator.id,
            :rut => collaborator.user.rut,
            :name => collaborator.user.name,
            :last_name => collaborator.user.last_name,
        }}

        @eval_collaborators = Evaluation.joins(evaluator: {collaborator: :user})
            .where("evaluations.collaborator_id = evaluators.collaborator_id")
            .where(["evaluators.period_id = ?", params[:id]])

        gon.eval_collaborators = @eval_collaborators.map{|collaborator| {
            :id => collaborator.evaluator.collaborator.id
        }}

        @eval_evaluators = Evaluation.joins(evaluator: {collaborator: :user})
            .where("evaluations.collaborator_id != evaluators.collaborator_id")
            .where(["evaluators.period_id = ?", params[:id]]).group("evaluators.collaborator_id")

        gon.eval_evaluators = @eval_evaluators.map {|evaluator| {
            :id => evaluator.evaluator.collaborator.id,
            :name => evaluator.evaluator.collaborator.user.name,
            :last_name => evaluator.evaluator.collaborator.user.last_name,
            :rut => evaluator.evaluator.collaborator.user.rut,
            :to_evaluate => Evaluation.joins(collaborator: :user, evaluator: {collaborator: :user})
                .where("evaluations.collaborator_id != evaluators.collaborator_id")
                .where(["evaluators.collaborator_id = ?", evaluator.evaluator.collaborator.id])
                .where(["evaluators.period_id = ?", params[:id]]).map {|collaborator| {
                    :id => collaborator.collaborator.id,
                }}
        }}

        @evaluators_select = @collaborators.map {|collaborator| {
            :id => collaborator.id,
            :rut => collaborator.user.rut,
            :name => collaborator.user.name,
            :last_name => collaborator.user.last_name,
            :selected => @eval_collaborators.where("evaluations.collaborator_id = #{collaborator.id}").empty?
        }}

    end

    def update
        period = Period.find(params[:id])
        aux_start = params[:start].split("-")
        aux_end = params[:end].split("-")
        period.start_date = "#{aux_start[2]}-#{aux_start[1]}-#{aux_start[0]}"
        period.finish_date = "#{aux_end[2]}-#{aux_end[1]}-#{aux_end[0]}"
        period.save

        EvaluationAbility.joins(evaluation: :evaluator).where("evaluators.period_id = #{params[:id]}").delete_all
        Evaluation.joins(:evaluator).where("evaluators.period_id = #{params[:id]}").delete_all
        Evaluator.where(:period_id => params[:id]).delete_all

        params[:collaborators].each do |collaborator_id|
            evaluator = Evaluator.create({
                :collaborator_id => collaborator_id,
                :period_id => period.id
            })
            collaborator = Collaborator.find(collaborator_id)
            Evaluation.create({
                :collaborator_id => collaborator_id,
                :evaluator_id => evaluator.id,
                :profile_id => collaborator.profile.id
            })
        end if (params[:collaborators].present?)

        params[:evaluates].each do |aux|
            evaluator = Evaluator.where(:period_id => period.id, :collaborator_id => aux[0]).first
            aux[1].each do |collaborator_id|
                collaborator = Collaborator.find(collaborator_id)
                Evaluation.create({
                    :collaborator_id => collaborator_id,
                    :evaluator_id => evaluator.id,
                    :profile_id => collaborator.profile.id
                })
            end
        end if (params[:evaluates].present?)


        redirect_to "/periods/#{period.id}"
    end

    def report
        @title = "Reporte"

        @collaborator = Collaborator.where(:id => params[:collaborator]).joins(:user).first

        @profile = Evaluation.joins(evaluator: {collaborator: :user}).joins(profile: {profile_abilities: :ability})
            .where("evaluations.collaborator_id = #{params[:collaborator]}")
            .where(["evaluators.period_id = ?", params[:period]]).first.profile

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

    def destroy
        EvaluationAbility.joins(evaluation: :evaluator).where("evaluators.period_id = #{params[:id]}").delete_all
        Evaluation.joins(:evaluator).where("evaluators.period_id = #{params[:id]}").delete_all
        Evaluator.where(:period_id => params[:id]).delete_all
        Period.find(params[:id]).delete

        redirect_to "/periods"
    end
end
