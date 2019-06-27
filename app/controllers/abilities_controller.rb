class AbilitiesController < ApplicationController

    def index
        @title = "Competencias"
        @abilities = Ability.joins(:abilities_type)
        @categories = Category.joins(:areas).uniq
        @areas = Area.all

        gon.categories = @categories.map {|category| {
            :id => category.id,
            :category => category.category,
            :areas => category.areas
        }}

        gon.abilities = @abilities.map {|ability| {
            :id => ability.id,
            :ability => ability.ability,
            :abilities_type_id => ability.abilities_type_id,
            :area => ability.area
        }}
        
        gon.areas = @areas
        

        @abilities = @abilities.where(['abilities.ability like ?', "%#{params[:ability]}%"]) if params[:ability].present?
        @abilities = @abilities.where(['abilities.abilities_type_id = ?', params[:category]]) if params[:category].present?
    end

    def update
        ability = Ability.find(params[:id])
        if(!params[:updated_type].present?)
            ability.ability = params[:updated_ability]
        elsif (params[:updated_type].to_i == 1)
            ability.ability = params[:updated_ability]
            ability.abilities_type_id = params[:updated_type].to_i
            ability.area_id = nil
        else
            area_id = nil

            if(params[:updated_blanda_area].to_i == 0)
                area = Area.create({
                    :area => params[:updated_blanda_area],
                    :category_id => category_id
                })
                area_id = area.id
            else
                area_id = params[:updated_blanda_area].to_i
            end
            
            ability.ability = params[:updated_ability]
            ability.abilities_type_id = params[:updated_type].to_i
            ability.area_id = area_id
        end

        ability.save

        redirect_to params[:route]
    end

    def create
        if (params[:new_type].to_i == 1)
            Ability.create({
                :ability => params[:new_ability],
                :abilities_type_id => params[:new_type].to_i,
            })
        else
            category_id = nil
            area_id = nil

            if(params[:new_blanda_category].to_i == 0)
                category = Category.create({
                    :category => params[:new_blanda_category]
                })
                category_id = category.id
            else
                category_id = params[:new_blanda_category].to_i
            end
            
            if(params[:new_blanda_area].to_i == 0)
                area = Area.create({
                    :area => params[:new_blanda_area],
                    :category_id => category_id
                })
                area_id = area.id
            else
                area_id = params[:new_blanda_area].to_i
            end
            
            Ability.create({
                :ability => params[:new_ability],
                :abilities_type_id => params[:new_type].to_i,
                :area_id => area_id
            })
        end

        redirect_to ability_url(params[:new_type].to_i)
    end

    def destroy
        ability = Ability.find(params[:id])
        EvaluationAbility.where(:ability_id => ability.id).delete_all
        ProfileAbility.where(:ability_id => ability.id).delete_all
        ability.destroy

        redirect_to "/abilities"
    end

    private def ability_url(type_name)
        url = "/abilities"
        if (type_name == 1)
            url = "/abilities/tecnicas"
        else
            url = "/abilities/blandas"
        end
        return url
    end

end
