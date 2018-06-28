class CustomAudit < Audited::Audit
    def pretty_changes
        pretty_changes = []

        self.audited_changes.each do |c| 
            if self.action == 'create'
                unless c.last.blank?
                    pretty_changes << "Item '#{c.first}' assign to '#{c.last}'"
                end
            elsif self.action == 'update'
                if c.last.first && c.last.last
                    pretty_changes << "Item '#{c.first}' change from '#{c.last.first}' to '#{c.last.last}'"
                end
            else
                pretty_changes << "Item '#{c.first}' was '#{c.last}'"
            end
        end
        pretty_changes.join('<br>')
    end
end