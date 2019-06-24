class LoginController < ApplicationController
    skip_before_action :signed_in

    def index
        if(signed_in?)
            redirect_to "/dashboard"
        else
            @user = User.new
            session[:user_id] = nil
            render :layout => 'empty'
        end
    end

    def logout
        session[:user_id] = nil
        redirect_to "/"
    end

    def authenticate
        user = User.where(:email => params[:user][:email], :password_digest => params[:user][:password_digest]).first
        if(user)
            collaborator = Collaborator.where(:user_id => user.id).first
            url = "/dashboard"
            if (collaborator)
                session[:collaborator_id] = collaborator.id
                url = "/autoevaluations"
            end
            session[:user_id] = user.id
            redirect_to url
        else
            flash[:mensaje] = "Credenciales Incorrectas"
            redirect_to :action => :index
        end
    end
end
