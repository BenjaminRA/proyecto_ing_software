class AutoevaluationsController < ApplicationController
    def new
        @title = "Evaluación"
        @collaborator = Collaborator.where(:id => params[:id]).joins(:user).joins(profile: :abilities).first
        @tecnicas_count = @collaborator.profile.abilities.where(:abilities_type_id => 1).count
        @blandas_count = @collaborator.profile.abilities.where(:abilities_type_id => 2).count
    end

    def create
        period = Period.where("start_date < :current_date and finish_date > :current_date", {
            :current_date => "#{Date.today} 00:00:00"
        }).first
        evaluation = Evaluation.joins(:evaluator)
            .where(["evaluations.collaborator_id = ?", session[:collaborator_id]])
            .where(["evaluators.collaborator_id = ?", params[:collaborator]])
            .where(["evaluators.period_id = ?", period.id]).first
        params[:abilities].each do |ability|
            EvaluationAbility.create({
                :ability_id => ability[0],
                :evaluation_id => evaluation.id,
                :value => ability[1][:value],
            })
            puts "#{ability[0]} -> #{ability[1][:value]}"
        end

        redirect_to "/autoevaluations"
    end

    def edit
        @title = "Editar Evaluación"
        period = Period.where("start_date < :current_date and finish_date > :current_date", {
            :current_date => "#{Date.today} 00:00:00"
        }).first
        @evaluation = Evaluation.joins(:evaluator)
            .where(["evaluations.collaborator_id = ?", session[:collaborator_id]])
            .where(["evaluators.collaborator_id = ?", params[:id]])
            .where(["evaluators.period_id = ?", period.id])
            .joins(evaluation_abilities: :ability).first
        @collaborator = Collaborator.where(:id => params[:id]).joins(:user).joins(profile: :abilities).first
        @tecnicas_count = @collaborator.profile.abilities.where(:abilities_type_id => 1).count
        @blandas_count = @collaborator.profile.abilities.where(:abilities_type_id => 2).count
    end

    def update
        period = Period.where("start_date < :current_date and finish_date > :current_date", {
            :current_date => "#{Date.today} 00:00:00"
        }).first
        evaluation = Evaluation.joins(:evaluator)
            .where(["evaluations.collaborator_id = ?", session[:collaborator_id]])
            .where(["evaluators.collaborator_id = ?", params[:collaborator]])
            .where(["evaluators.period_id = ?", period.id]).first
        params[:abilities].each do |ability|
            evaluation = EvaluationAbility.find(ability[1][:id])
            evaluation.value = ability[1][:value]
            evaluation.save
        end
        redirect_to "/autoevaluations"
    end

    def index
        @title = "Autoevaluación"
        period = Period.where("start_date < :current_date and finish_date > :current_date", {
            :current_date => "#{Date.today} 00:00:00"
        }).first
        if(!period.nil?)
            @evaluation = Evaluation.joins(:evaluator)
                .where(["evaluations.collaborator_id = ?", session[:collaborator_id]])
                .where(["evaluators.collaborator_id = ?", session[:collaborator_id]])
                .where(["evaluators.period_id = ?", period.id])
                .joins(evaluation_abilities: :ability).first
        end
        @collaborator = Collaborator.where(:user_id => session[:user_id]).joins(:user).joins(profile: :abilities).first
        @tecnicas_count = @collaborator.profile.abilities.where(:abilities_type_id => 1).count
        @blandas_count = @collaborator.profile.abilities.where(:abilities_type_id => 2).count
    end
end
