class ProfilesController < ApplicationController
    def index
        @title = "Perfiles"
        @abilities = Ability.all
        @profiles = Profile.joins(:abilities)

        @profiles = @profiles.where(['profile like ?', "%#{params[:profile]}%"]) if params[:profile].present?

        params[:abilities].each do |ability|
            @profiles = @profiles.where(['profile_abilities.ability_id = ?', ability])
        end if params[:abilities].present?

        @profiles = @profiles.uniq
    end

    def create
        profile = Profile.create({
            :profile => params[:profileName],
            :description => params[:description]
        })
        params[:profile][:profile_abilities_attributes].each do |ability|
            ProfileAbility.create({
                :profile_id => profile[:id],
                :ability_id => ability[1][:ability],
                :value => ability[1][:value]
            })
        end

        redirect_to profiles_path
    end

    def new
        @title = "Crear Perfiles"
        @profile = Profile.new
        @abilities = Ability.new
        @tecnicas = Ability.where('category_id = 1')
        @blandas = Ability.where('category_id = 2')
    end
end
