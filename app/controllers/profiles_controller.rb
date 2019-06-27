class ProfilesController < ApplicationController
    before_action :is_admin
    
    def index
        @title = "Perfiles"
        @abilities = Ability.all
        @profiles = Profile.joins(profile_abilities: :ability)
        


        @profiles = @profiles.where(['profile like ?', "%#{params[:profile]}%"]) if params[:profile].present?

        @profiles = @profiles.where(['profile_abilities.ability_id = ?', params[:abilities]]) if params[:abilities].present?

        # params[:abilities].each do |ability|
        #     @profiles = @profiles.where(['profile_abilities.ability_id = ?', ability])
        # end if params[:abilities].present?

        @profiles = @profiles.uniq
    end

    def create
        profile = Profile.create({
            :profile => params[:profile][:profile],
            :objective => params[:profile][:objective],
            :functions => params[:profile][:functions]
        })

        puts profile.inspect

        params[:profile][:profile_abilities_attributes].each do |ability|
            ProfileAbility.create({
                :profile_id => profile[:id],
                :ability_id => ability[1][:ability],
                :value => ability[1][:value]
            })
        end

        if (params[:reports_tos].present? && !params[:reports_tos].empty?)
            params[:reports_tos].each do |profile_id|
                # ActiveRecord::Base.connection.execute("insert into reports_tos(sender_id, reciever_id, created_at, updated_at) values(#{profile.id}, #{profile_id}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
                ReportsTo.create({
                    :sender_id => profile.id,
                    :reciever_id => profile_id
                })
            end
        end
        
        if (params[:direct_supervisions].present? && !params[:direct_supervisions].empty?)
            params[:direct_supervisions].each do |profile_id|
                # ActiveRecord::Base.connection.execute("insert into direct_supervisions(from_id, to_id, created_at, updated_at) values(#{profile_id}, #{profile.id}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")                
                DirectSupervision.create({
                    :from_id => profile_id,
                    :to_id => profile.id
                })
            end 
        end

        if (params[:replace_bies].present? && !params[:replace_bies].empty?)
            params[:replace_bies].each do |profile_id|
                # ActiveRecord::Base.connection.execute("insert into replace_bies(to_replace_id, replacement_id, created_at, updated_at) values(#{profile.id}, #{profile_id}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
                ReplaceBy.create({
                    :to_replace_id => profile.id,
                    :replacement_id => profile_id
                })
            end
        end

        redirect_to profiles_path
    end

    def destroy
        profile = Profile.find(params[:id])

        ReportsTo.where(sender_id: profile.id).delete_all
        ReportsTo.where(reciever_id: profile.id).delete_all

        DirectSupervision.where(from_id: profile.id).delete_all
        DirectSupervision.where(to_id: profile.id).delete_all

        ReplaceBy.where(to_replace_id: profile.id).delete_all
        ReplaceBy.where(replacement_id: profile.id).delete_all
        
        profile.destroy

        redirect_to profiles_path
    end

    def edit
        @title = "Editar Perfil"
        @profile = Profile.find(params[:id])
        @profiles = Profile.all

        @abilities = Ability.new

        gon.profile = {
            :id => @profile.id,
            :profile => @profile.profile,
            :objective => @profile.objective,
            :functions => @profile.functions,
            :reports_tos => ReportsTo.joins("INNER JOIN profiles ON reports_tos.sender_id = profiles.id").where(["profiles.id = ?", params[:id]]),
            :direct_supervisions => DirectSupervision.joins("INNER JOIN profiles ON direct_supervisions.to_id = profiles.id").where(["profiles.id = ?", params[:id]]),
            :replace_bies => ReplaceBy.joins("INNER JOIN profiles ON replace_bies.to_replace_id = profiles.id").where(["profiles.id = ?", params[:id]]),
            :abilities => @profile.abilities
        }
        @tecnicas = Ability.where('abilities_type_id = 1')
        @blandas = Ability.where('abilities_type_id = 2')

        # render :plain => @profile.abilities.inspect
    end

    def update
        profile = Profile.find(params[:id])
        profile.profile = params[:profile][:profile]
        profile.objective = params[:profile][:objective]
        profile.functions = params[:profile][:functions]
        profile.save

        if (params[:reports_tos].present? && !params[:reports_tos].empty?)
            reports_tos = ReportsTo.where(sender_id: profile.id).map {|entry| entry.reciever_id}
            params[:reports_tos].each do |profile_id|
                if(reports_tos.include? profile_id)
                    reports_tos.delete(profile_id)
                else
                    ReportsTo.create({
                        :sender_id => profile.id,
                        :reciever_id => profile_id
                    })
                end
            end
            reports_tos.each do |entry|
                aux = ReportsTo.where(sender_id: profile.id, reciever_id: entry).first
                aux.destroy
            end
        end
        
        if (params[:direct_supervisions].present? && !params[:direct_supervisions].empty?)
            direct_supervision = DirectSupervision.where(to_id: profile.id).map {|entry| entry.from_id}
            params[:direct_supervisions].each do |profile_id|
                if(direct_supervision.include? profile_id)
                    direct_supervision.delete(profile_id)
                else
                    DirectSupervision.create({
                        :from_id => profile_id,
                        :to_id => profile.id
                    })
                end
            end
            direct_supervision.each do |entry|
                aux = DirectSupervision.where(from_id: entry, to_id: profile.id).first
                aux.destroy
            end
        end

        if (params[:replace_bies].present? && !params[:replace_bies].empty?)
            replace_bies = ReplaceBy.where(to_replace_id: profile.id).map {|entry| entry.replacement_id}
            params[:replace_bies].each do |profile_id|
                if(replace_bies.include? profile_id)
                    replace_bies.delete(profile_id)
                else
                    ReplaceBy.create({
                        :to_replace_id => profile.id,
                        :replacement_id => profile_id
                    })
                end
            end
            replace_bies.each do |entry|
                aux = ReplaceBy.where(to_replace_id: profile.id, replacement_id: entry).first
                aux.destroy
            end
        end

        aux = profile.abilities.map {|ability| ability.id}

        params[:profile][:profile_abilities_attributes].each do |ability|
            if (ability[1][:ability].present?)

                profile_ability = ProfileAbility.where(:profile_id => profile[:id], :ability_id => ability[1][:ability]).first
                if(profile_ability.nil?)
                    ProfileAbility.create({
                        :profile_id => profile[:id],
                        :ability_id => ability[1][:ability],
                        :value => ability[1][:value]
                    })
                else
                    aux.delete(profile_ability.ability_id)
                    profile_ability.value = ability[1][:value]
                    profile_ability.save
                end
            end
        end

        aux.each do |id|
            profile_ability = ProfileAbility.where(:profile_id => profile[:id], :ability_id => id).first
            profile_ability.destroy
        end

        redirect_to profiles_path
    end

    def new
        @title = "Crear Perfil"
        @profile = Profile.new
        @profiles = Profile.all
        @abilities = Ability.new

        @tecnicas = Ability.where('abilities_type_id = 1')
        @blandas = Ability.where('abilities_type_id = 2')
    end

    def show
        @title = "Perfil"
        @profile = Profile.joins(profile_abilities: :ability).find(params[:id])
        @reports_to = ReportsTo.where(:sender_id => @profile.id)
        @direct_supervision = DirectSupervision.where(:to_id => @profile.id)
        @replace_by = ReplaceBy.where(:to_replace_id => @profile.id)

        @reports_to = @reports_to.map{|entry| Profile.find(entry.reciever_id).profile}
        @direct_supervision = @direct_supervision.map{|entry| Profile.find(entry.from_id).profile}
        @replace_by = @replace_by.map{|entry| Profile.find(entry.replacement_id).profile}

        categories = Category.all

        @blandas = categories.map{|category| {
            :category => category.category,
            :areas => Area.where(:category_id => category.id).map{|area| {
                :area => area.area,
                :abilities => ProfileAbility.joins(:ability).where("abilities.area_id = #{area.id}").where("profile_abilities.profile_id = #{@profile.id}")
            }}
        }}
    end
end
