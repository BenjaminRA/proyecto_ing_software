class CollaboratorsController < ApplicationController

    def index
        @title = "Colaboradores"
        @collaborators = User.joins(collaborator: [:profile, :state])
        # puts @collaborators.inspect


        @categories = Category.all
        @areas = Area.all

        gon.categories = @categories
        gon.areas = @areas

        # render :plain => @collaborators[0].collaborator.profile.inspect
    end

    def new
        @title = "Crear Colaborador"
        @collaborator = User.new
        @profiles = Profile.all

        @categories = Category.all
        @areas = Area.all

        gon.categories = @categories
        gon.areas = @areas

    end

    def show
        @categories = Category.all
        @areas = Area.all

        gon.categories = @categories
        gon.areas = @areas
    end

    def edit
        @collaborator = User.joins(collaborator: [:profile, :state]).where(["users.id = ?", params[:id]]).first
        @profiles = Profile.all
        
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
