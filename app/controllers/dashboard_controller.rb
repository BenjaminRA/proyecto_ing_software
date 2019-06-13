class DashboardController < ApplicationController

    def index
        @title = "Dashboard"
        render :layout => 'application'
    end
end
