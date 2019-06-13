class AreasController < ApplicationController
    before_action :is_admin
    
    def index
        @title = "Competencias Blandas - Categorias"

        @areas = @areas.where(['areas.area like ?', "%#{params[:area]}%"]) if params[:area].present?
        @areas = @areas.where(['areas.category_id = ?', params[:category]]) if params[:category].present?
    end

    def destroy
        area = Area.find(params[:id])
        area.destroy

        redirect_to "/abilities/blandas/areas"
    end

    def update
        area = Area.find(params[:id])
        area.area = params[:updated_area]
        area.category_id = params[:updated_category]
        area.save
        redirect_to "/abilities/blandas/areas"
    end
end
