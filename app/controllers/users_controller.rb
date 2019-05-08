class UsersController < ApplicationController

    def index
        @title = "Usuarios"
        puts params[:nombre] if params[:nombre].present?
    end

    def new

    end

    def show

    end
    
end
