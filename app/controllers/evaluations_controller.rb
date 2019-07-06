class EvaluationsController < ApplicationController
    include EvaluationsHelper
    before_action :check_period

    def index
        period = Period.where("start_date < :current_date and finish_date > :current_date", {
            :current_date => "#{Date.today} 00:00:00"
        }).first
        if(!period.nil?)
            @evaluations = Evaluation.joins(:evaluator).joins(collaborator: :user)
                .where("evaluations.collaborator_id != evaluators.collaborator_id")
                .where(["evaluators.collaborator_id = ?", session[:collaborator_id]])
                .where(["evaluators.period_id = ?", period.id])
        end
    end

    def show
        @evaluation = Evaluation.where(:id => params[:id]).joins(collaborator: [:user, :profile]).first
        @evaluation_abilities = EvaluationAbility.where(:evaluation_id => params[:id]).joins(:ability)
        # render :plain => @evaluation.collaborator.inspect
    end

    def edit
        @evaluation = Evaluation.where(:id => params[:id]).joins(collaborator: [:user, :profile]).first
    end

    def update
        params[:abilities].each do |ability|
            evaluation = EvaluationAbility.find(ability[1][:id])
            evaluation.value = ability[1][:value]
            evaluation.save
        end

        redirect_to "/evaluations/#{params[:evaluation]}"
    end

    def create
        params[:abilities].each do |ability|
            EvaluationAbility.create({
                :ability_id => ability[0],
                :evaluation_id => params[:evaluation],
                :value => ability[1][:value],
            })
        end

        redirect_to "/evaluations"
    end

    def new
        @evaluation = Evaluation.where(:id => params[:id]).joins(collaborator: [:user, :profile]).first
    end
end
