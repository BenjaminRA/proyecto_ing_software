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
                ActiveRecord::Base.connection.execute("insert into reports_tos(sender_id, reciever_id, created_at, updated_at) values(#{profile.id}, #{profile_id}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
                # ReportsTo.create({
                #     :sender_id => profile.id,
                #     :reciever_id => profile_id
                # })
            end
        end
        
        if (params[:direct_supervisions].present? && !params[:direct_supervisions].empty?)
            params[:direct_supervisions].each do |profile_id|
                ActiveRecord::Base.connection.execute("insert into direct_supervisions(from_id, to_id, created_at, updated_at) values(#{profile_id}, #{profile.id}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")                
                # DirectSupervision.create({
                #     :from_id => profile_id,
                #     :to_id => profile.id
                # })
            end 
        end

        if (params[:replace_bies].present? && !params[:replace_bies].empty?)
            params[:replace_bies].each do |profile_id|
                ActiveRecord::Base.connection.execute("insert into replace_bies(to_replace_id, replacement_id, created_at, updated_at) values(#{profile.id}, #{profile_id}, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)")
                # ReplaceBy.create({
                #     :to_replace_id => profile.id,
                #     :replacement_id => profile_id
                # })
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

    def new
        @title = "Crear Perfiles"
        @profile = Profile.new
        @profiles = Profile.all
        @abilities = Ability.new
        @categories = Category.all
        @areas = Area.all

        gon.categories = @categories
        gon.areas = @areas
        @tecnicas = Ability.where('abilities_type_id = 1')
        @blandas = Ability.where('abilities_type_id = 2')
    end
end
