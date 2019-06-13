class ApplicationController < ActionController::Base
    include ApplicationHelper
    before_action :ability_helper
    before_action :signed_in

    def index
        @title = "Dashboard"

    end

end
