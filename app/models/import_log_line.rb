# Encoding: utf-8

class ImportLogLine < ActiveRecord::Base
  belongs_to :import_log

  enum etat: [:succès, :echec]

end
