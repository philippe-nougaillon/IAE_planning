class Vacation < ActiveRecord::Base

  audited

  belongs_to :formation
  belongs_to :intervenant


  def self.activités
    {
      "Direction mémoire" => 0.25,
      "Membre jury"	=> 0.75,
      "Rapports de stage" => 1,
      "Tutorat apprenti" =>	2,
      "VAE examen dossier/participation au jury" => 3,
      "Réunion pédagogique_jury de MAE"	=>	7.5,
      "Entretiens de sélection" => 1	
    }
  end

end
