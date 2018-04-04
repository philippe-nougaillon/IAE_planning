# Encoding: utf-8

class ImportLog < ActiveRecord::Base

    has_many :import_log_lines

    validates :model_type, :etat, presence: true

    enum etat: [:succès, :echec]

end
