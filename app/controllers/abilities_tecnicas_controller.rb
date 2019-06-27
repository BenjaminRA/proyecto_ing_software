class AbilitiesTecnicasController < ApplicationController
    def index
        @title = "Competencias Técnicas"
        @abilities = Ability.where(['abilities_type_id = ?', 1])
        @categories = Category.joins(:areas)
        @areas = Area.all
        
        gon.categories = @categories.map {|category| {
            :id => category.id,
            :category => category.category,
            :areas => category.areas
        }}

        gon.abilities = @abilities


        @abilities = @abilities.where(['ability like ?', "%#{params[:ability]}%"]) if params[:ability].present?
    end

    def update
        ability = Ability.find(params[:id])
        ability.ability = params[:updated_ability]
        ability.abilities_type_id = params[:updated_type].to_i
        ability.area_id = nil

        ability.save

        redirect_to "/abilities/tecnicas"
    end

    def create
        Ability.create({
            :ability => params[:new_ability],
            :abilities_type_id => params[:new_type].to_i,
        })

        redirect_to "/abilities/tecnicas"
    end

    def destroy
        ability = Ability.find(params[:id])
        EvaluationAbility.where(:ability_id => ability.id).delete_all
        ProfileAbility.where(:ability_id => ability.id).delete_all
        ability.destroy

        redirect_to "/abilities/tecnicas"
    end
end
