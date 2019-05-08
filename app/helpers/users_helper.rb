module UsersHelper
    def state_class(state)
        if (state == "activo")
            "label-primary"
        elsif (state == "inactivo")
            "label-danger"
        else
            "label-warning"
        end
    end
end
