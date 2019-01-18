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

    def can_see_RHGroup_private_tool?
        ['philippe.nougaillon@gmail.com',
        'cunha.iae@univ-paris1.fr',
        'fitsch-mouras.iae@univ-paris1.fr',
        'manzano.iae@univ-paris1.fr',
        'denis.iae@univ-paris1.fr']
        .include?(user.email)
    end
end
    