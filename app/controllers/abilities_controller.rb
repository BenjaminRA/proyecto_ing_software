class AbilitiesController < ApplicationController
    def index
        @title = "Habilidades"
        @abilities = Ability.all
        @categories = Category.all

        @abilities = @abilities.where(['ability like ?', "%#{params[:ability]}%"]) if params[:ability].present?
        @abilities = @abilities.where(['category_id = ?', params[:category]]) if params[:category].present?
    end

    def show
        ability = Ability.find(params[:id])
        puts ability.inspect
        ability.update({
            :ability => params[:updated_ability],
            :category_id => params[:updated_category]
        })

        puts params

        redirect_to abilities_path
    end

    def create
        category = Category.find(params[:new_category])
        category.ability.create({
            :ability => params[:new_ability],
        })

        redirect_to abilities_path
    end

    def destroy
        puts params
        ability = Ability.find(params[:id])
        ability.destroy

        redirect_to abilities_path
    end

    private def ability_params
        params.require([:ability, :category])
        return {
            :ability => params[:ability],
        }
    end


end
