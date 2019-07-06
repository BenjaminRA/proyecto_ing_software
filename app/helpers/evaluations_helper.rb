module EvaluationsHelper

    def check_period
        period = Period.where("start_date < :current_date and finish_date > :current_date", {
            :current_date => "#{Date.today} 00:00:00"
        }).first
        if(period.nil?)
            redirect_to "/autoevaluations"
        end
    end
    
end
