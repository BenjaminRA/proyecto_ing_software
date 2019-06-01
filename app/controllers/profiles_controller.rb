class ProfilesController < ApplicationController
    def index
        @title = "Perfiles"
        @abilities = Ability.all
        @profiles = Profile.joins(:abilities)
        
        @categories = Category.all
        @areas = Area.all

        gon.categories = @categories
        gon.areas = @areas

        @profiles = @profiles.where(['profile like ?', "%#{params[:profile]}%"]) if params[:profile].present?

        params[:abilities].each do |ability|
            @profiles = @profiles.where(['profile_abilities.ability_id = ?', ability])
        end if params[:abilities].present?

        @profiles = @profiles.uniq
    end

    def create
        profile = Profile.create({
            :profile => params[:profile][:profile],
            :objective => params[:profile][:objective],
            :functions => params[:profile][:functions]
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
        @categories = Category.all
        @areas = Area.all

        gon.categories = @categories
        gon.areas = @areas
        @tecnicas = Ability.where('abilities_type_id = 1')
        @blandas = Ability.where('abilities_type_id = 2')
    end
end
