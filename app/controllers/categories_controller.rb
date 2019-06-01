class CategoriesController < ApplicationController
    def index
        @title = "Competencias Blandas - Categorias"
        @categories = Category.all
        gon.categories = @categories

        @categories = @categories.where(['categories.category like ?', "%#{params[:category]}%"]) if params[:category].present?
    end

    def destroy
        category = Category.find(params[:id])
        category.destroy

        redirect_to "/abilities/blandas/categories"
    end

    def update
        category = Category.find(params[:id])
        category.category = params[:updated_category]
        category.save
        redirect_to "/abilities/blandas/categories"
    end
end
