class EvaluationsController < ApplicationController
    def new
        # @collaborator = Collaborator.where(:user_id => session[:user_id]).joins(profile: :abilities).first
        @collaborator = Collaborator.where(:user_id => session[:user_id]).joins(:user).joins(profile: :abilities).first
        @tecnicas_count = @collaborator.profile.abilities.where(:abilities_type_id => 1).count
        @blandas_count = @collaborator.profile.abilities.where(:abilities_type_id => 2).count
    end

    def index

    end
end
