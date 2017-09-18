class ToolPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        scope
      end
    end
  
    def import_utilisateurs?
        user.admin?
    end
    
    def swap_intervenant?
        user.admin?
    end

end
    