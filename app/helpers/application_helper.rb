module ApplicationHelper

    def is_active_controller(controller_name, class_name = nil)
        if params[:controller] == controller_name
         class_name == nil ? "active" : class_name
        else
           nil
        end
    end

    def is_active_action(action_name)
        params[:action] == action_name ? "active" : nil
    end

    def is_active_controller_action(controller_name, action_name)
        params[:action] == action_name && params[:controller] == controller_name ? "active" : nil
    end

    def asset_exists?(subdirectory, filename)
      File.exists?(File.join(Rails.root, 'app', 'assets', subdirectory, filename))
    end

    def image_exists?(image)
      asset_exists?('images', image)
    end

    def javascript_exists?(script)
      extensions = %w(.coffee .erb .coffee.erb) + [""]
      extensions.inject(false) do |truth, extension|
        truth || asset_exists?('javascripts', "#{script}.js#{extension}")
      end
    end

    def stylesheet_exists?(stylesheet)
      extensions = %w(.scss .erb .scss.erb) + [""]
      extensions.inject(false) do |truth, extension|
        truth || asset_exists?('stylesheets', "#{stylesheet}.css#{extension}")
      end
    end

    def ability_helper
      @user = Admin.where(:user_id => session[:user_id]).joins(:user).first
      unless(@user) 
        @user = Collaborator.where(:user_id => session[:user_id]).joins(:user).first
      end
      @categories = Category.all
      @areas = Area.all

      gon.categories = @categories
      gon.areas = @areas
    end

    def signed_in
      if(!session[:user_id].present? && request.fullpath != "/")
        redirect_to "/"
      elsif(request.fullpath == "/")
        redirect_to "/dashboard"
      end
    end

    def signed_in?
      return session[:user_id].present?
    end

    def is_admin
      user = Admin.where(:user_id => session[:user_id]).first
      unless(user)
        redirect_to "/"
      end
    end

    def is_admin?
      return !@user.methods.include?(:profile)
    end

    def to_autoevaluate?
      period = Period.where("start_date < :current_date and finish_date > :current_date", {
        :current_date => Date.today
      }).first
      if(period.nil?)
        return false
      else
        evaluation = Evaluation.joins(:evaluator).where("evaluations.collaborator_id = evaluators.collaborator_id")
          .where(["evaluations.collaborator_id = ?", session[:user_id]])
          .where(["evaluators.period_id = ?", period.id])
        return evaluation.exists?
      end
    end

    def autoevalation_done?
      period = Period.where("start_date < :current_date and finish_date > :current_date", {
        :current_date => Date.today
      }).first
      if(period.nil?)
        return false
      else
        evaluation = Evaluation.joins(:evaluator).where("evaluations.collaborator_id = evaluators.collaborator_id")
          .where(["evaluations.collaborator_id = ?", session[:user_id]])
          .where(["evaluators.period_id = ?", period.id])
          .joins(:evaluation_abilities)
        return evaluation.exists?
      end
    end
end
