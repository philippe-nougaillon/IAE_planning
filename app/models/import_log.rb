# Encoding: utf-8

class ImportLog < ActiveRecord::Base

    has_many :import_log_lines

    validates :model_type, :etat, presence: true

    enum etat: [:succès, :echec]

    def icon_etat
        if self.etat == "succès"
          "glyphicon glyphicon-ok-circle text-success"
        else
          "glyphicon glyphicon-remove-circle text-danger"
        end
      end  
    
end
