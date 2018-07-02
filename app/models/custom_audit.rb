# ENCODING: UTF-8

class CustomAudit < Audited::Audit
    def pretty_changes
        pretty_changes = []

        self.audited_changes.each do |c| 
            if self.action == 'create'
                unless c.last.blank?
                    pretty_changes << "'#{c.first}' a été initialisé à '#{c.last}'"
                end
            elsif self.action == 'update'
                if c.last.first && c.last.last
                    pretty_changes << "'#{c.first}' modifié de '#{c.last.first}' à '#{c.last.last}'"
                end
            else
                pretty_changes << "'#{c.first}' était '#{c.last}'"
            end
        end
        pretty_changes.join('<br>')
    end
end