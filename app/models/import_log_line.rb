# Encoding: utf-8

class ImportLogLine < ActiveRecord::Base
  belongs_to :import_log

  enum etat: [:succès, :echec]

  def icon_etat
    if self.etat == "succès"
      "glyphicon glyphicon-ok-circle text-success"
    else
      "glyphicon glyphicon-remove-circle text-danger"
    end
  end  

end
