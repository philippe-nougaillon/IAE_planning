# Encoding: utf-8

class Cour < ActiveRecord::Base

  audited

  belongs_to :formation
  belongs_to :intervenant
  belongs_to :salle

  validates :formation_id, :intervenant_id, presence: true

  enum etat: [:nouveau, :plannifié, :a_placer, :placé]

  before_validation(on: :create) do
      self.user = RequestStore.store[:current_user]
  end

  def self.styles
  	 ['label-default','label-primary','label-warning','label-success']
  end

  def style
	  Cour.styles[Cour.etats[self.etat]]
  end
	
  def duree
  	((self.fin - self.debut) / 60) / 60
  end

 def start_time
    self.debut 
 end

end
