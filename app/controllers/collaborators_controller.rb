class CollaboratorsController < ApplicationController
    before_action :is_admin

    def index
        @title = "Colaboradores"
        @collaborators = User.joins(collaborator: [:profile, :state])
        @profiles = Profile.all

        @collaborators = @collaborators.where(['users.name like ?', "%#{params[:nombre]}%"]) if params[:nombre].present?
        @collaborators = @collaborators.where(['users.last_name like ?', "%#{params[:apellido]}%"]) if params[:apellido].present?
        @collaborators = @collaborators.where(["users.rut = ?", "#{params[:rut]}"]) if params[:rut].present?
        @collaborators = @collaborators.where(["users.email like ?", "%#{params[:email]}%"]) if params[:email].present?
        @collaborators = @collaborators.where(["collaborators.profile_id = ?", "#{params[:perfil]}"]) if params[:perfil].present?
        @collaborators = @collaborators.where(["collaborators.state_id = ?", "#{params[:status]}"]) if params[:status].present?
    end

    def new
        @title = "Crear Colaborador"
        @collaborator = User.new
        @profiles = Profile.all
    end

    def show
        @title = "Colaborador"

        @collaborator = Collaborator.joins(:profile, :user).where(["users.id = ?", params[:id]]).first
        @reports_to = ReportsTo.where(:sender_id => @collaborator.profile.id)
        @direct_supervision = DirectSupervision.where(:to_id => @collaborator.profile.id)
        @replace_by = ReplaceBy.where(:to_replace_id => @collaborator.profile.id)

        @reports_to = @reports_to.map{|entry| Profile.find(entry.reciever_id).profile}
        @direct_supervision = @direct_supervision.map{|entry| Profile.find(entry.from_id).profile}
        @replace_by = @replace_by.map{|entry| Profile.find(entry.replacement_id).profile}

        categories = Category.all

        @blandas = categories.map{|category| {
            :category => category.category,
            :areas => Area.where(:category_id => category.id).map{|area| {
                :area => area.area,
                :abilities => ProfileAbility.joins(:ability).where("abilities.area_id = #{area.id}").where("profile_abilities.profile_id = #{@collaborator.profile.id}")
            }}
        }}

        # render :plain => categories.inspect

    end

    def edit
        @title = "Editar Colaborador"

        @collaborator = User.joins(collaborator: [:profile, :state]).where(["users.id = ?", params[:id]]).first
        @profiles = Profile.all
        @states = State.all
        
        @categories = Category.all
        @areas = Area.all
        
        gon.profile = @collaborator.collaborator.profile.id
        gon.categories = @categories
        gon.areas = @areas
    end

    def update
        user = User.find(params[:id])
        user.name = params[:user][:name]
        user.last_name = params[:user][:last_name]
        user.rut = params[:user][:rut]
        user.email = params[:user][:email]
        user.password_digest = params[:user][:password_digest]
        user.save

        collaborator = Collaborator.where({
            :user_id => user.id
        }).first

        collaborator.profile_id = params[:user][:profile_id]
        collaborator.state_id = params[:user][:state_id]
        
        collaborator.save

        redirect_to collaborators_path

    end

    def create
        user = User.create({
            :name => params[:user][:name],
            :last_name => params[:user][:last_name],
            :rut => params[:user][:rut],
            :email => params[:user][:email],
            :password_digest => params[:user][:password_digest],
        })

        Collaborator.create({
            :user_id => user.id,
            :profile_id => params[:user][:profile_id],
            :state_id => 1
        })

        redirect_to collaborators_path
    end

    def destroy
        user = User.find(params[:id])

        Collaborator.where(user_id: user.id).delete_all
        
        user.destroy

        redirect_to collaborators_path
    end
    
end
