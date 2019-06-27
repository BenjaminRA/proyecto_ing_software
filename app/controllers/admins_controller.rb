class AdminsController < ApplicationController
    before_action :is_admin

    def index
        @title = "Administradores"
        @admins = User.joins(:admin)

        @admins = @admins.where(['users.name like ?', "%#{params[:nombre]}%"]) if params[:nombre].present?
        @admins = @admins.where(['users.last_name like ?', "%#{params[:apellido]}%"]) if params[:apellido].present?
        @admins = @admins.where(["users.rut = ?", "#{params[:rut]}"]) if params[:rut].present?
        @admins = @admins.where(["users.email like ?", "%#{params[:email]}%"]) if params[:email].present?

    end

    def new
        @title = "Crear Administrador"
        @admin = User.new
    end

    def show

    end

    def edit
        @title = "Editar Administrador"
        @admin = User.joins(:admin).where(["users.id = ?", params[:id]]).first
        
        @categories = Category.all
        @areas = Area.all
        
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

        redirect_to admins_path

    end

    def create
        user = User.create({
            :name => params[:user][:name],
            :last_name => params[:user][:last_name],
            :rut => params[:user][:rut],
            :email => params[:user][:email],
            :password_digest => params[:user][:password_digest],
        })

        Admin.create({
            :user_id => user.id,
        })

        redirect_to admins_path
    end

    def destroy
        user = User.find(params[:id])

        Admin.where(user_id: user.id).delete_all
        
        user.destroy

        redirect_to admins_path
    end
    
end
