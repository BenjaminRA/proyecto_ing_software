module CollaboratorsHelper
    def state_class(state)
        if (state == "Activo")
            "label-primary"
        elsif (state == "Inactivo")
            "label-danger"
        else
            "label-warning"
        end
    end
end
