module ToolsHelper

    def prettify(audit)    
        pretty_changes = []
        
        audit.audited_changes.each do |c|
            if audit.action == 'create'
                pretty_changes << "#{c.first}' initialisé à '#{c.last}'"
            elsif audit.action == 'update' 
                pretty_changes << "'#{c.first}' modifié de '#{c.last.first}' à '#{c.last.last}'" 
            else 
                pretty_changes << "'#{c.first}' était à '#{c.last}'"
            end
        end
        pretty_changes
    end

    def audited_view_path(audit)
        case audit.auditable_type
        when "Cour"
            if Cour.exists?(audit.auditable_id)
                cour_path(audit.auditable_id)
            end
        when "User"
            if User.exists?(audit.auditable_id)
                user_path(audit.auditable_id)
            end
        when "Formation"
            if Formation.exists?(audit.auditable_id)
                formation_path(audit.auditable_id)
            end
        when "Intervenant"
            if Intervenant.exists?(audit.auditable_id)
                intervenant_path(audit.auditable_id)
            end
        when "Etudiant"
            if Etudiant.exists?(audit.auditable_id)
                etudiant_path(audit.auditable_id)
            end
        when "Salle"
            if Salle.exists?(audit.auditable_id)
                salle_path(audit.auditable_id)
            end
        when "Fermeture"
            if Fermeture.exists?(audit.auditable_id)
                fermeture_path(audit.auditable_id)
            end
        end
    end

    def convertir_id_salles(audit)

        if audit.audited_changes.include?("salle_id") && audit.action !=  'destroy'
            salle_id = audit.audited_changes["salle_id"] 
            if salle_id.class.name == "Array" 
                if salle_id_was = salle_id.first 
                    salle_before = Salle.find(salle_id_was).nom 
                end 
                if salle_id = salle_id.last 
                    salle_after = Salle.find(salle_id).nom 
                end 
                return "#{salle_before} -> #{salle_after}"
            else 
                if salle_id.class.name == "Integer" 
                    salle_after = Salle.find(salle_id).nom 
                else 
                    salle_after = salle_id 
                end
                return "= #{salle_after}"
            end  
        end 

    end

end
